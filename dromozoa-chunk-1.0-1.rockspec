-- This file was automatically generated for the LuaDist project.

package = "dromozoa-chunk"
version = "1.0-1"
-- LuaDist source
source = {
  tag = "1.0-1",
  url = "git://github.com/LuaDist-testing/dromozoa-chunk.git"
}
-- Original source
-- source = {
--   url = "https://github.com/dromozoa/dromozoa-chunk/archive/v1.0.tar.gz";
--   file = "dromozoa-chunk-1.0.tar.gz";
-- }
description = {
  summary = "Binary chunk reader and writer";
  license = "GPL-3";
  homepage = "https://github.com/dromozoa/dromozoa-chunk/";
  maintainer = "Tomoyuki Fujimori <moyu@dromozoa.com>";
}
build = {
  type = "builtin";
  modules = {
    ["dromozoa.chunk.ieee754"] = "dromozoa/chunk/ieee754.lua";
    ["dromozoa.chunk.integer"] = "dromozoa/chunk/integer.lua";
    ["dromozoa.chunk.opcode_decoder"] = "dromozoa/chunk/opcode_decoder.lua";
    ["dromozoa.chunk.opcode_encoder"] = "dromozoa/chunk/opcode_encoder.lua";
    ["dromozoa.chunk.opcodes_5_1"] = "dromozoa/chunk/opcodes_5_1.lua";
    ["dromozoa.chunk.opcodes_5_2"] = "dromozoa/chunk/opcodes_5_2.lua";
    ["dromozoa.chunk.opcodes_5_3"] = "dromozoa/chunk/opcodes_5_3.lua";
    ["dromozoa.chunk.reader"] = "dromozoa/chunk/reader.lua";
    ["dromozoa.chunk.swap"] = "dromozoa/chunk/swap.lua";
    ["dromozoa.chunk.writer"] = "dromozoa/chunk/writer.lua";
  };
}