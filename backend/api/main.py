from fastapi import FastAPI
from ptyprocess import PtyProcessUnicode
from typing import Tuple, List
from .VHDLBackend import VHDLBackend

app = FastAPI()

# GHDL simulation process started by `make`.
process = PtyProcessUnicode.spawn(['make'], echo=False)
backend = VHDLBackend(process)


@app.get("/board-size")
async def board_size() -> Tuple[int, int]:
    return backend.get_board_size()


@app.get("/state")
async def next_state() -> List[List[bool]]:
    return backend.get_next_board_state()


@app.post("/state")
async def set_state(state: List[List[bool]]) -> None:
    backend.set_board_state(state)
