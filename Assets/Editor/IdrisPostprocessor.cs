using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;

/// <summary>
///   Rebuilds the Idris package upon Idris source file changes.
/// </summary>
public class IdrisPostprocessor : AssetPostprocessor {

        static string IdrisPath = HomePath (".local/bin");

        static string Idris = Path.Combine (IdrisPath, "idris");

        static string IlasmPath = "/usr/local/bin";

        static void OnPostprocessAllAssets (string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths) {

                if (!importedAssets.Concat(deletedAssets).Concat(movedAssets).Concat(movedFromAssetPaths).Any (IsIdrisFile))
                        return;

                Debug.Log ("Starting Idris build");

                var packagePath = IdrisPackagePath ();
                var processStartInfo = new System.Diagnostics.ProcessStartInfo {
                        FileName = Idris,
                        Arguments = "--build " + packagePath,
                        WorkingDirectory = Path.GetDirectoryName (packagePath),
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        UseShellExecute = false,
                };
                var envVars = processStartInfo.EnvironmentVariables;
                envVars["PATH"] = envVars["PATH"]
                        + Path.PathSeparator + IdrisPath
                        + Path.PathSeparator + IlasmPath;

                var idris = System.Diagnostics.Process.Start (processStartInfo);
                idris.WaitForExit ();
                Debug.Log (idris.StandardOutput.ReadToEnd () + idris.StandardError.ReadToEnd ());
                if (idris.ExitCode == 0) {
                        Debug.Log ("Idris build successful.");
                        AssetDatabase.ImportAsset ("Assets/Idris/IdrisUnity.dll");
                } else
                        Debug.LogError ("Idris build failed!");
        }

        static string HomePath (string path) {
                return Path.Combine (System.Environment.GetFolderPath (System.Environment.SpecialFolder.Personal), path);
        }

        static string IdrisPackagePath () {
                return Path.Combine (Application.dataPath, "Idris/IdrisUnity.ipkg");
        }

        static bool IsIdrisFile (string f) {
                var ext = Path.GetExtension (f);
                return ext.CompareTo (".idr") == 0
                        || ext.CompareTo (".ipkg") == 0;
        }
}
