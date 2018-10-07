module Multibase

using CodecBase
using Base58

Encoding = UInt8

const Identity = Encoding(0x00)
const Base16 = Encoding('f')
const Base32 = Encoding('b')
const Base58BTC = Encoding('z')
const Base64 = Encoding('m')

encodingLookup = Dict([
                       ('f', Base16),
                       ('b', Base32),
                       ('z', Base58BTC),
                       ('m', Base64),
                      ])

convert(::Type{Encoding}, x) = Encoding(x)



function encode(enc::Encoding, data::T) where T <: Union{Vector{UInt8},
                                                         DenseArray{UInt8,1},
                                                         NTuple{N, UInt8} where N}

    if Identity == enc
        pushfirst!(data, Identity)
    elseif Base16 == enc
        pushfirst!(transcode(Base16Encoder(), data), Base16)
    elseif Base32 == enc
        pushfirst!(transcode(Base32Encoder(), data), Base32)
    elseif Base58BTC == enc
        pushfirst!(base58encode(data), Base58BTC)
    elseif Base64 == enc
        pushfirst!(transcode(Base64Encoder(), data), Base64)
    else
        throw(ArgumentError(enc, "no associated encoding"))
    end
end

function lookup(prefix::Char)
    return get(encodingLookup, prefix, missing)
end

function decode(data::AbstractString)
    enc = lookup(data[1])
    hash = data[2:length(data)]

    if Identity == enc
        (popfirst!(hash), Identity)
    elseif Base16 == enc
        (String(transcode(Base16Decoder(), hash)), Base16)
    elseif Base32 == enc
        (String(transcode(Base32Decoder(), hash)), Base32)
    elseif Base58BTC == enc
        (String(base58decode(Vector{UInt8}(hash))), Base58BTC)
    elseif Base64 == enc
        (String(transcode(Base64Decoder(), hash)), Base64)
    else
        throw(ArgumentError(enc, "no associated encoding"))
    end
end

end # module
