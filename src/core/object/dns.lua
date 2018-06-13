-- Copyright (c) 2018, OARC, Inc.
-- All rights reserved.
--
-- This file is part of dnsjit.
--
-- dnsjit is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dnsjit is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dnsjit.  If not, see <http://www.gnu.org/licenses/>.

-- dnsjit.core.object.dns
-- Container of a DNS message
--   local query = require("dnsjit.core.object.dns")
--   local q = query.new(pkt)
--   print(q:src(), q:dst(), q.id, q.rcode)
--
-- The object that describes a DNS message.
-- .SS Attributes
-- .TP
-- src_id
-- Source ID, used to track the query through the input, filter and output
-- modules.
-- See also
-- .BR dnsjit.core.tracking (3).
-- .TP
-- qr_id
-- Query/Response ID, used to track the query through the input, filter
-- and output modules.
-- See also
-- .BR dnsjit.core.tracking (3).
-- .TP
-- dst_id
-- Destination ID, used to track the query through the input, filter
-- and output modules.
-- See also
-- .BR dnsjit.core.tracking (3).
-- .TP
-- sport
-- Source port.
-- .TP
-- dport
-- Destination port.
-- .TP
-- have_id
-- Set if there is a DNS ID.
-- .TP
-- have_qr
-- Set if there is a QR flag.
-- .TP
-- have_opcode
-- Set if there is an OPCODE.
-- .TP
-- have_aa
-- Set if there is a AA flag.
-- .TP
-- have_tc
-- Set if there is a TC flag.
-- .TP
-- have_rd
-- Set if there is a RD flag.
-- .TP
-- have_ra
-- Set if there is a RA flag.
-- .TP
-- have_z
-- Set if there is a Z flag.
-- .TP
-- have_ad
-- Set if there is a AD flag.
-- .TP
-- have_cd
-- Set if there is a CD flag.
-- .TP
-- have_rcode
-- Set if there is a RCODE.
-- .TP
-- have_qdcount
-- Set if there is an QDCOUNT.
-- .TP
-- have_ancount
-- Set if there is an ANCOUNT.
-- .TP
-- have_nscount
-- Set if there is a NSCOUNT.
-- .TP
-- have_arcount
-- Set if there is an ARCOUNT.
-- .TP
-- id
-- The DNS ID.
-- .TP
-- qr
-- The QR flag.
-- .TP
-- opcode
-- The OPCODE.
-- .TP
-- aa
-- The AA flag.
-- .TP
-- tc
-- The TC flag.
-- .TP
-- rd
-- The RD flag.
-- .TP
-- ra
-- The RA flag.
-- .TP
-- z
-- The Z flag.
-- .TP
-- ad
-- The AD flag.
-- .TP
-- cd
-- The CD flag.
-- .TP
-- rcode
-- The RCODE.
-- .TP
-- qdcount
-- The QDCOUNT.
-- .TP
-- ancount
-- The ANCOUNT.
-- .TP
-- nscount
-- The NSCOUNT.
-- .TP
-- arcount
-- The ARCOUNT.
-- .TP
-- questions
-- The actual number of questions found.
-- .TP
-- answers
-- The actual number of answers found.
-- .TP
-- authorities
-- The actual number of authorities found.
-- .TP
-- additionals
-- The actual number of additionals found.
module(...,package.seeall)

require("dnsjit.core.object.dns_h")
local ffi = require("ffi")
local C = ffi.C

local t_name = "core_object_dns_t"
local core_object_dns_t
local Dns = {}

-- Create a new DNS object ontop of a packet or payload object.
function Dns.new(obj)
    local self = C.core_object_dns_new(obj)
    if self ~= nil then
        ffi.gc(self, C.core_object_dns_free)
    end
    return self
end

-- Return the textual type of the object.
function Dns:type()
    return "dns"
end

-- Return the previous object.
function Dns:prev()
    return self.obj_prev
end

-- Cast the object to the underlining object module and return it.
function Dns:cast()
    return self
end

-- Cast the object to the generic object module and return it.
function Dns:uncast()
    return ffi.cast("core_object_t*", self)
end

-- Make a copy of the object and return it.
function Dns:copy()
    return C.core_object_dns_copy(self)
end

-- Free the object, should only be used on copies or otherwise allocated.
function Dns:free()
    C.core_object_dns_free(self)
end

-- Return the Log object to control logging of this instance or module.
function Dns:log()
    return C.core_object_dns_log()
end

-- Parse the DNS headers or the query, returns 0 on success.
function Dns:parse_header()
    return C.core_object_dns_parse_header(self)
end

-- Parse the full DNS message or just the body if the header was already
-- parsed, returns 0 on success.
function Dns:parse()
    return C.core_object_dns_parse(self)
end

-- Return the IP source as a string.
function Dns:src()
    return ffi.string(C.core_object_dns_src(self))
end

-- Return the IP destination as a string.
function Dns:dst()
    return ffi.string(C.core_object_dns_dst(self))
end

-- Reset the walking of resource record(s), returns 0 on success.
function Dns:rr_reset()
    return C.core_object_dns_rr_reset(self)
end

-- Start walking the resource record(s) (RR) found or continue with the next.
-- Returns 0 on success, < 0 on end of RRs and > 0 on error.
function Dns:rr_next()
    return C.core_object_dns_rr_next(self)
end

-- Check if the RR at the current position was parsed successfully or not,
-- returns 1 if successful.
function Dns:rr_ok()
    return C.core_object_dns_rr_ok(self)
end

-- Return the FQDN of the current RR or nil on error.
function Dns:rr_label()
    local ptr = C.core_object_dns_rr_label(self)
    if ptr == nil then
        return
    end
    return ffi.string(ptr)
end

-- Return an integer with the RR type.
function Dns:rr_type()
    return C.core_object_dns_rr_type(self)
end

-- Return an integer with the RR class.
function Dns:rr_class()
    return C.core_object_dns_rr_class(self)
end

-- Return an integer with the RR TTL.
function Dns:rr_ttl()
    return C.core_object_dns_rr_ttl(self)
end

-- Print the content of this DNS message if previously parsed, returns 0 on
-- success.
function Dns:print()
    if self:rr_reset() ~= 0 then
        return
    end

    local flags = {}
    if self.have_aa and self.aa == 1 then
        table.insert(flags, "AA")
    end
    if self.have_tc and self.tc == 1 then
        table.insert(flags, "TC")
    end
    if self.have_rd and self.rd == 1 then
        table.insert(flags, "RD")
    end
    if self.have_ra and self.ra == 1 then
        table.insert(flags, "RA")
    end
    if self.have_z and self.z == 1 then
        table.insert(flags, "Z")
    end
    if self.have_ad and self.ad == 1 then
        table.insert(flags, "AD")
    end
    if self.have_cd and self.cd == 1 then
        table.insert(flags, "CD")
    end

    print("id:", self.id)
    print("", "qr:", self.qr)
    print("", "opcode:", self.opcode)
    print("", "flags:", table.concat(flags, " "))
    print("", "rcode:", self.opcode)
    print("", "qdcount:", self.qdcount)
    print("", "ancount:", self.ancount)
    print("", "nscount:", self.nscount)
    print("", "arcount:", self.arcount)
    local n = self.questions
    print("", "questions:")
    while n > 0 and self:rr_next() == 0 do
        if self:rr_ok() == 1 then
            print("", "", self:rr_class(), self:rr_type(), self:rr_label())
        end
        n = n - 1
    end
    n = self.answers
    print("", "answers:")
    while n > 0 and self:rr_next() == 0 do
        if self:rr_ok() == 1 then
            print("", "", self:rr_class(), self:rr_type(), self:rr_ttl(), self:rr_label())
        end
        n = n - 1
    end
    n = self.authorities
    print("", "authorities:")
    while n > 0 and self:rr_next() == 0 do
        if self:rr_ok() == 1 then
            print("", "", self:rr_class(), self:rr_type(), self:rr_ttl(), self:rr_label())
        end
        n = n - 1
    end
    n = self.additionals
    print("", "additionals:")
    while n > 0 and self:rr_next() == 0 do
        if self:rr_ok() == 1 then
            print("", "", self:rr_class(), self:rr_type(), self:rr_ttl(), self:rr_label())
        end
        n = n - 1
    end
end

core_object_dns_t = ffi.metatype(t_name, { __index = Dns })

-- dnsjit.core.object (3),
-- dnsjit.core.object.packet (3),
-- dnsjit.core.object.payload (3),
-- dnsjit.core.tracking (3)
return Dns
