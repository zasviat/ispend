import os

from pathlib import Path
from fastapi import APIRouter
from fastapi.responses import FileResponse

router = APIRouter()

main_page_path = Path(__file__).parent.parent.parent / "static" / "dist" / "index.html"


@router.get("/{full_path:path}")
async def index():
    if os.path.exists(main_page_path):
        return FileResponse(main_page_path)
