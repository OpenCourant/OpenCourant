import sys
import os

# Release version, see VERSIONING.md. Read from the VERSION file rather than
# from git: source archives of a release carry no git metadata.
VERSION_FILE=os.path.join(os.path.dirname(os.path.abspath(__file__)),
                          '..','..','VERSION')

def read_version():
  try:
    with open(VERSION_FILE) as fh:
      version=fh.read().strip()
  except OSError:
    return 'unknown'
  return version if version else 'unknown'

# ===========================================
# Main entry point
# ===========================================

if __name__ == "__main__":

  # initialization
  arch="none"
  git_sha=""
  msg=" "
  outfile="build_info.inc"
  version=read_version()

  
  # Parse argument lists
  for arg in sys.argv:

    argument=arg.split('=')

    if(argument[0] == '-outfile'):
      size=len(argument)
      if (size == 2):
        outfile=argument[1]

    if(argument[0] == '-version'):
      size=len(argument)
      if (size == 2):
        version=argument[1]


    if (argument[0] == '-arch'):

      size=len(argument)
      if (size == 2):
        arch=argument[1]

    if(argument[0] == '-msg'):
      size=len(argument)
      if (size == 2):
        msg=argument[1]

  arch_len=len(arch)
  line='       DATA BNAME/\"'+arch+'\"/\n'
  line_len='       DATA LENBNAM/'+str(arch_len)+'/\n'
  msg_line='       DATA  MSGO/\''+msg+'\'/\n'

  #grep RADIOSS_SHA_HEADER variable
  git_sha=os.getenv('RADIOSS_SHA_HEADER','')
  if ( len(git_sha) > 0): 
      btag='       DATA BTAG/\'CommitID: '+git_sha+'\'/\n'
  else:
      btag='       DATA BTAG/\' \'/\n'

  # VERS is declared CHARACTER*32 below; a longer string would be truncated
  if (len(version) > 32):
    sys.exit("or_build_info.py: version %r exceeds 32 characters" % version)

  print("")
  print("Create:",outfile,"version:",version)
  print("")

  with open(outfile,'w') as include_file:
    include_file.write("       CHARACTER VERS*32, BDATE*32, BTIME*32,BTAG*80, MSGO*68,BNAME*32\n")
    include_file.write("       CHARACTER YEARSTRING*11\n")
    include_file.write("       INTEGER LEN_VERS, LEN_BDATE, LEN_BTIME, PMSG,LEN_MSG\n")
    include_file.write("       INTEGER LENBNAM\n")
    include_file.write("\n")
    include_file.write("       DATA VERS/\""+version+"\"/\n")
    include_file.write("       PARAMETER (LEN_VERS="+str(len(version))+")\n")
    include_file.write("\n")
    include_file.write("       DATA BDATE/__DATE__/\n")
    include_file.write("\n")
    include_file.write("       DATA BTIME/__TIME__/\n")
    include_file.write("\n")
    include_file.write(line)
    include_file.write(line_len)
    include_file.write("\n")
    include_file.write(btag)
    include_file.write("       PARAMETER (PMSG=0)\n")
    include_file.write(msg_line)
    include_file.write("       PARAMETER (LEN_MSG=1)\n")
