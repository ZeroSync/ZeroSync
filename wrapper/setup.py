import toml
import os

from wrapper.cairo import compileCairo

INIT_WORK_DIR = "work/"
VALIDATE_PROG = "validate_compiled.json"


# Returns a dictionary containing btc client configuration, compiled
# sourceDir paths and working path directory
# creates them when not present
def ctxConfigSetup(configFile, sourceDir, forceCompile):
    if not os.path.exists(configFile):
        while (1):
            createNewConf = input(
                "No config file found.\nDo you want to create a new one in " +
                "'" +
                os.getcwd() +
                "/" +
                INIT_WORK_DIR +
                "'? [y/N]:") or "N"
            if createNewConf.lower() == "y":
                break
            if createNewConf.lower() == "n":
                exit(0)

        print("Provide Bitcoin-client RPC information.")
        host = input("Host [localhost]: ") or "localhost"
        port = input("Port [8332]: ") or "8332"
        user = input("User: ")
        psw = input("Password: ")
        print("sibd will create a working directory for compiled cairo programs and program traces.")
        workDir = (input("Working directory path [./work/]: ") or "work") + "/"
        os.makedirs(workDir)
        workDir = os.path.abspath(workDir) + "/"
        config = {
            "title": "starkRelay config file",
            "btc-client": {
                "host": host,
                "port": port,
                "user": user,
                "psw": psw
            },
            "work": {
                "dir": workDir
            }
        }
        with open(configFile, 'w+') as f:
            print(toml.dumps(config), file=f)

    ctxDict = toml.load(configFile)
    if not os.path.exists(ctxDict['work']['dir']):
        print(
            "No working directory set up... creating new one at " +
            ctxDict['work']['dir'])
        os.makedirs(ctxDict['work']['dir'])
    workDir = ctxDict['work']['dir']

    if (not os.path.exists(sourceDir) and not (os.path.exists(
            workDir + VALIDATE_PROG) or not os.path.exists(workDir + MERKLE_PROG))):
        sourceDir = os.path.abspath(source)
        print("ERROR: Source directory " + sourceDir +
              " does not exist. Specify a sourceDir directory using --source.")
        exit(3)
    validateSrcFile = sourceDir + "/validate.cairo"
    # Compile the files and store in our work_dir
    if not os.path.exists(workDir + VALIDATE_PROG) or forceCompile:
        print("Compiling " + validateSrcFile + "...")
        if not compileCairo(validateSrcFile, workDir + VALIDATE_PROG):
            print("ERROR: Unable to compile validate sourceDir file.")
            exit(1)
        print("Done.")
    ctxDict['validate'] = workDir + VALIDATE_PROG
    return ctxDict
