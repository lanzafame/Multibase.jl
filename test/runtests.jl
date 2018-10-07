using Multibase
using Test

@testset "Multibase.Encode" begin

    test_data = hcat(
        [[Multibase.Base16, b"foobar"], b"f666F6F626172"],
        [[Multibase.Base32, b"foobar"], b"bMZXW6YTBOI======"],
        [[Multibase.Base58BTC, b"foobar"], b"zt1Zv2yaZ"],
        [[Multibase.Base64, b"foobar"], b"mZm9vYmFy"],
    )

    for i in 1:size(test_data, 2)
        case = test_data[1, i]
        @test Multibase.encode(case[1], case[2]) == test_data[2, i]
    end
end


@testset "Multibase.Decode" begin

    test_data = hcat(
         ["f666F6F626172", ("foobar", Multibase.Base16)],
         ["bMZXW6YTBOI======", ("foobar", Multibase.Base32)],
         ["zt1Zv2yaZ", ("foobar", Multibase.Base58BTC)],
         ["mZm9vYmFy", ("foobar", Multibase.Base64)],
        )

    for i in 1:size(test_data, 2)
        result = test_data[2, i]
        @test Multibase.decode(test_data[1, i]) == result
    end
end
