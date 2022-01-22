import time
from ptyprocess import PtyProcessUnicode
from typing import Tuple, List


class VHDLBackend:
    """
    VHDL backend management class.
    """

    def __init__(self, process: PtyProcessUnicode):
        self.process = process

        # Wait for the backend to start.
        time.sleep(1)

        # Clear and print the output until the backend prints "READY".
        while True:
            line = self.process.readline()
            print(f"VHDLBackend: [init] {line.strip()}")
            if line.startswith("READY"):
                break

        self.board_size = self.get_board_size()

    def __del__(self):
        self.process.close()

    def _command(self, command: str, arguments: List[str] = []) -> List[str]:
        """
        Sends a command to the backend.
        """

        # Build the command string.
        self.process.write(command + "\n")
        print(f"VHDLBackend: [send] {command}")

        # Check command confirmation.
        assert self.process.readline().startswith(command)

        # Send the arguments.
        for argument in arguments:
            self.process.write(f"{argument}\n")
            print(f"VHDLBackend: [send] {argument}")

        # Empty list.
        output = []

        # Read the output.
        while True:
            line = self.process.readline().strip()
            if line.endswith("*"):
                break
            print(f"VHDLBackend: [recv] {line}")
            output.append(line)

        return output

    def get_board_size(self) -> Tuple[int, int]:
        """
        Returns the board size as a tuple of ints.
        """

        # Send x to get the x-size.
        x = int(self._command("x")[0])

        # Send y to get the y-size.
        y = int(self._command("y")[0])

        return x, y

    def get_board_state(self) -> List[List[bool]]:
        """
        Returns the current board state as a list of lists of bools.
        """

        # Send s to get the board state.
        board_state = self._command("p")

        # Convert the board state to a list of lists of bools.
        result: List[List[bool]] = []
        for line in board_state:
            result.append(list(map(lambda x: True if x == "1" else False, line)))

        return result

    def set_board_state(self, board_state: List[List[bool]]):
        """
        Sets the current board state to the given board state.
        """

        # Convert the board state to a list of lists of ints.
        command_lines = []
        for line in board_state:
            command_lines.append("".join(map(lambda x: "1" if x else "0", line)))

        # Send the board state.
        self._command("l", command_lines)

    def step(self):
        """
        Steps the simulation.
        """

        # Send the step command.
        self._command("s")
