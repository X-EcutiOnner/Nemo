//
// Copyright (C) 2020-2021  Andrei Karas (4144)
//
// Hercules is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

function exe_setJmpVa(patchAddr, jmpAddrVa)
{
    var vars = {
        "offset": jmpAddrVa,
    };
    var code = asm.textToHexRaw(patchAddr, "jmp offset", vars);
    if (code === false)
        throw "Jmp code error";

    exe.replace(patchAddr, code, PTYPE_HEX);
}

function exe_setJmpRaw(patchAddr, jmpAddrRaw)
{
    exe_setJmpVa(patchAddr, exe.Raw2Rva(jmpAddrRaw));
}

function exe_setNops(patchAddr, nopsCount)
{
    var code = "";
    for (var i = 0; i < nopsCount; i ++)
    {
        code = code + "90 ";
    }
    exe.replace(patchAddr, code, PTYPE_HEX);
}

function exe_setNopsRange(patchStartAddr, patchEndAddr)
{
    exe_setNops(patchStartAddr, patchEndAddr - patchStartAddr);
}

function exe_insertAsmText(commands, vars)
{
    var size = asm.textToHexVaLength(0, commands, vars);

    var free = exe.findZeros(size);
    if (free === -1)
        throw "Failed in exe.insertAsm - Not enough free space";

    var obj = asm.textToHexRaw(free, commands, vars);
    if (obj === false)
        throw "Asm code error";

    exe.insert(free, size, obj, PTYPE_HEX);
    return [free, obj];
}

function exe_replaceAsmText(patchAddr, commands, vars)
{
    var obj = asm.textToHexRaw(patchAddr, commands, vars);
    if (obj === false)
        throw "Asm code error";

    exe.replace(patchAddr, obj, PTYPE_HEX);
    return obj;
}

function registerExe()
{
    exe.setJmpVa = exe_setJmpVa;
    exe.setJmpRaw = exe_setJmpRaw;
    exe.setNops = exe_setNops;
    exe.setNopsRange = exe_setNopsRange;
    exe.insertAsmText = exe_insertAsmText;
    exe.replaceAsmText = exe_replaceAsmText;
}
