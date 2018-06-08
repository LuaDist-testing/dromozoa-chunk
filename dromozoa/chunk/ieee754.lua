-- Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
--
-- This file is part of dromozoa-chunk.
--
-- dromozoa-chunk is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dromozoa-chunk is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dromozoa-chunk.  If not, see <http://www.gnu.org/licenses/>.

local swap = require "dromozoa.chunk.swap"

if string.pack then
  local function specifier(size)
    if size == 4 then
      return "f"
    elseif size == 8 then
      return "d"
    end
  end

  return {
    decode = function (endian, size, s, position)
      return ((endian .. specifier(size)):unpack(s, position))
    end;

    encode = function (endian, size, v)
      return (endian .. specifier(size)):pack(v)
    end;
  }
else
  local unpack = table.unpack or unpack

  local function constant(size)
    if size == 4 then
      return 126, 255, 128
    elseif size == 8 then
      return 1022, 2047, 16
    end
  end

  return {
    decode = function (endian, size, s, position)
      local BIAS, FILL, SHIFT = constant(size)

      if not position then
        position = 1
      end
      local buffer = { s:byte(position, position + size - 1) }
      if endian == "<" then
        swap(buffer)
      end

      local ab = buffer[1] * 256 + buffer[2]
      local sign = 1
      if ab >= 0x8000 then
        ab = ab - 0x8000
        sign = -1
      end
      local x = ab % SHIFT
      local exponent = (ab - x) / SHIFT
      local fraction = 0
      for i = size, 3, -1 do
        fraction = (fraction + buffer[i]) / 256
      end
      fraction = (fraction + x) / SHIFT

      if exponent == FILL then
        if fraction == 0 then
          return sign * math.huge
        else
          return 0 / 0
        end
      elseif exponent == 0 then
        if fraction == 0 then
          if sign > 0 then
            return 0
          else
            return -1 / math.huge
          end
        else
          return sign * math.ldexp(fraction, exponent - BIAS)
        end
      else
        return sign * math.ldexp((fraction + 1) / 2, exponent - BIAS)
      end
    end;

    encode = function (endian, size, v)
      local BIAS, FILL, SHIFT = constant(size)

      local sign = 0
      local exponent = 0
      local fraction = 0

      if -math.huge < v and v < math.huge then
        if v == 0 then
          if string.format("%g", v):sub(1, 1) == "-" then
            sign = 0x8000
          end
        else
          if v < 0 then
            sign = 0x8000
          end
          local m, e = math.frexp(v)
          if e <= -BIAS then
            fraction = math.ldexp(m, e + BIAS)
          else
            exponent = e + BIAS
            fraction = m * 2 - 1
          end
        end
      else
        exponent = FILL
        if v ~= math.huge then
          sign = 0x8000
          if v ~= -math.huge then
            fraction = 0.5
          end
        end
      end

      local buffer = {}
      local b, fraction = math.modf(fraction * SHIFT)
      for i = 3, size do
        buffer[i], fraction = math.modf(fraction * 256)
      end
      local ab = sign + exponent * SHIFT + b
      local x = ab % 256
      buffer[1] = (ab - x) / 256
      buffer[2] = x

      if endian == "<" then
        swap(buffer)
      end
      return string.char(unpack(buffer))
    end;
  }
end
