using DbUp;
using DbUp.Engine;
using System;
using System.Reflection;
using Npgsql;

namespace Kauko.DbUpdater
{
    class Program
    {
        static int Main(string[] args)
        {
            try
            {
                if (args.Length <= 5)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine("");
                    Console.WriteLine("Usage: ./Kauko.DbUp.exe [Operation] [ConnectionString] [Srid] [MunicipalityCode] [MunicipalityName] [GkNumber]");
                    Console.WriteLine("");
                    Console.WriteLine("Examples of [ConnectionString]:");
                    Console.WriteLine("\"Server=127.0.0.1;Port=5432;Database=myDataBase;Integrated Security=true;\"");
                    Console.WriteLine("\"Server=127.0.0.1;Port=5432;Database=myDataBase;User Id=myUsername;Password=myPassword;\"");
                    Console.WriteLine("");
                    Console.WriteLine("[Operation]         [Description]");
                    Console.WriteLine(" update              Updates sql scripts that are not already executed");
                    Console.WriteLine(" mark                Mark all scripts as executed");
                    Console.WriteLine(" markinitial         Mark initial scripts as executed");
                    Console.WriteLine(" info                List all unexecuted scripts");
                    Console.WriteLine("");
                    Console.ResetColor();
                    return -1;
                }

                Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.InvariantCulture;
                Thread.CurrentThread.CurrentUICulture = System.Globalization.CultureInfo.InvariantCulture;

                var connectionString = args[1];
				int srid = int.Parse(args[2]);
				var municipalityCode = args[3];
				var municipalityName = args[4];
				var gkNumber = args[5];

                EnsureDatabase.For.PostgresqlDatabase(connectionString);

                DatabaseUpgradeResult result;

                UpgradeEngine upgrader;
                bool isFirstRun = CheckIfFirstRun(connectionString, municipalityName.ToLower() + "_gk" + gkNumber);


                if (args.FirstOrDefault() == "markinitial")
                {
                    throw new NotImplementedException();
                }
                else
                {
                    upgrader = DeployChanges.To
                      .PostgresqlDatabase(connectionString)
                      // drop views script: run always first, except for on the first run do not run at all
                      .WithScriptsEmbeddedInAssembly(
                        Assembly.GetExecutingAssembly(), 
                        script => !isFirstRun && script.Equals("Kauko.DbUp.Scripts.views.kauko_views_drop.sql"), 
                        new SqlScriptOptions { ScriptType = DbUp.Support.ScriptType.RunAlways, RunGroupOrder = 1 }
                      )
                      // numbered patch scripts
                      .WithScriptsEmbeddedInAssembly(
                        Assembly.GetExecutingAssembly(), 
                        script => !script.StartsWith("Kauko.DbUp.Scripts.views.kauko_views_"),  
                        new SqlScriptOptions { ScriptType = DbUp.Support.ScriptType.RunOnce, RunGroupOrder = 2 }
                      )
                      // create views script: run always last
                      .WithScriptsEmbeddedInAssembly(
                        Assembly.GetExecutingAssembly(), 
                        script => script.Equals("Kauko.DbUp.Scripts.views.kauko_views_create.sql"), 
                        new SqlScriptOptions { ScriptType = DbUp.Support.ScriptType.RunAlways, RunGroupOrder = 3 }
                      )
                      .WithVariablesEnabled()
					  .WithVariable("BODY", "$BODY$") // This is a bug or at least a misfeature in DbUp
					  .WithVariable("function", "$function$") // This is a bug or at least a misfeature in DbUp
					  .WithVariable("PROJECTSRID", srid.ToString())
					  .WithVariable("MUNICIPALITYCODE", municipalityCode)
					  .WithVariable("SCHEMANAME", municipalityName.ToLower() + "_gk" + gkNumber)
                      .LogToConsole()
                      .Build();
                }

                if (args.FirstOrDefault() == "mark")
                {
                    result = upgrader.MarkAsExecuted();
                }
                else if (args.FirstOrDefault() == "info")
                {
                    var scripts = upgrader.GetScriptsToExecute();

                    Console.WriteLine("Scripts that need to be run:");
                    foreach (var sc in scripts)
                    {
                        Console.WriteLine(sc.Name);
                    }

                    return 0;
                }
                else
                {
                    result = upgrader.PerformUpgrade();
                }

                if (!result.Successful)
                {
                    Console.ForegroundColor = ConsoleColor.Red;
                    Console.WriteLine(result.Error);
                    Console.ResetColor();
#if DEBUG
                    Console.ReadLine();
#endif
                    return -1;
                }

                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("Success!");
                Console.ResetColor();
                return 0;
            }
            catch (Exception e)
            {
                Console.ForegroundColor = ConsoleColor.Red;
                Console.WriteLine(e.Message);
                Console.ResetColor();
            }

            return -1;
        }

        private static bool CheckIfFirstRun(string connectionString, string schemaName)
        {
            using (var connection = new NpgsqlConnection(connectionString))
            {
                connection.Open();
                using (var command = new NpgsqlCommand(
                    "SELECT schema_name FROM information_schema.schemata WHERE schema_name = @schemaName",
                    connection))
                {
                    command.Parameters.AddWithValue("@schemaName", schemaName);
                    using (var reader = command.ExecuteReader())
                    {
                        return !reader.HasRows; // Returns true if the schema does not exist, i.e., it's the first run
                    }
                }
            }
        }
    }
}
