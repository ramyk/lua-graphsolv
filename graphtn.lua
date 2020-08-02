-- ALL NUMERICAL DATA IS HANDLY COLLECTED FROM
-- https://distancecalculator.globefeed.com/

-- encoder: from governorates names to codes
local encoder = {
    Bizerte = "bz", Ariana = "ar", Manouba = "mb",
    Tunis = "tn", BenArous = "ba", Beja = "bj",
    Jendouba = "jd", Nabeul = "nb", Zaghouane = "zg",
    ElKef = "kf", Sousse = "ss", Siliana = "sl",
    Monastir = "ms", Kairouan = "kr", Kasserine = "ks",
    Mahdia = "mh", SidiBouzid = "sb", Sfax = "sf",
    Gafsa = "gf", Gabes = "gb", Tozeur = "tz",
    Medenine = "md", Kebili = "kb", Tataouine = "tt"
}

-- decoder: from codes to governorates names
local decoder = {
    bz = "Bizerte", ar = "Ariana", mb = "Manouba",
    tn = "Tunis", ba = "BenArous", bj = "Beja",
    jd = "Jendouba", nb = "Nabeul", zg = "Zaghouane",
    kf = "ElKef", ss = "Sousse", sl = "Siliana",
    ms = "Monastir", kr = "Kairouan", ks = "Kasserine",
    mh = "Mahdia", sb = "SidiBouzid", sf = "Sfax",
    gf = "Gafsa", gb = "Gabes", tz = "Tozeur",
    md = "Medenine", kb = "Kebili", tt = "Tataouine"
}

-- direct access geomap of tunisia:
-- each code represents a tunisian governorate
-- each value array is the governorates that can
-- be directly accessed from the key governorate
-- associated with the path cost of getting there
local map = {
    bz = { ar=63, mb=77, bj=105 },
    ar = { bz=63, mb=14, tn=8 },
    mb = { bz=77, ar=14, tn=8, bj=108, zg=64 },
    tn = { ar=8, mb=9, ba=8, nb=77 },
    ba = { tn=8, nb=71, zg=51 },
    bj = { bz=105, mb=108, jd=50, zg=133, sl=102 },
    jd = { bj=50, kf=48, sl=101 },
    nb = { tn=77, ba=71, zg=59, ss=110 },
    zg = { mb=64, ba=51, bj=133, nb=59, ss=104, sl=106, kr=102 },
    kf = { jd=48, sl=73, ks=131 },
    ss = { nb=110, zg=104, ms=24, kr=56 },
    sl = { bj=102, jd=101, zg=106, kf=73, kr=100, ks=167, sb=147 },
    ms = { ss=24, mh=45 },
    kr = { zg=102, ss=56, sl=100, mh=125, sb=118, sf=175 },
    ks = { kf=131, sl=167, sb=75, gf=110 },
    mh = { ms=45, kr=125, sf=136 },
    sb = { sl=147, kr=118, ks=75, sf=131, gf=100, gb=174 },
    sf = { kr=175, mh=136, sb=131, gb=139 },
    gf = { ks=110, sb=100, gb=157, tz=93, kb=110 },
    gb = { sb = 174, sf=139, gf=157, md=78, kb=120 },
    tz = { gf=93, kb=97 },
    md = { gb=78, kb=194, tt=51 },
    kb = { gf=110, gb=120, tz=97, md=194, tt=240 },
    tt = { md=51, kb=240 }
}

-- straight line distance heuristic array:
-- in heuristic-based searchs algorithms, SLD is
-- the heuristic used, each entry in the array is the SLD
-- distance between the key governorate and the other 23 governorates
local sld = {
    bz = { bz=0, ar=54, mb=56, tn=59, ba=66, bj=86, jd=130, nb=119,
           zg=100, kf=159, ss=175, sl=140, ms=187, kr=179, ks=252, mh=224,
           sb=251, sf=293, gf=332, gb=378, tz=405, md=440, kb=405, tt=486 },
    ar = { bz=54, ar=0, mb=10, tn=7, ba=12, bj=118, jd=133, nb=66,
           zg=52, kf=152, ss=122, sl=114, ms=133, kr=132, ks=225, mh=170,
           sb=212, sf=241, gf=300, gb=331, tz=377, md=391, kb=369, tt=438 },
    mb = { bz=56, ar=10, mb=0, tn=7, ba=12, bj=82, jd=123, nb=69,
           zg=46, kf=142, ss=119, sl=104, ms=131, kr=126, ks=215, mh=169,
           sb=204, sf=237, gf=290, gb=325, tz=367, md=386, kb=360, tt=432 },
    tn = { bz=59, ar=7, mb=7, tn=0, ba=7, bj=89, jd=129, nb=63,
           zg=45, kf=148, ss=116, sl=108, ms=128, kr=126, ks=219, mh=165,
           sb=205, sf=235, gf=293, gb=325, tz=370, md=385, kb=362, tt=431 },
    ba = { bz=66, ar=12, mb=12, tn=7, ba=0, bj=92, jd=131, nb=57,
           zg=45, kf=149, ss=110, sl=107, ms=121, kr=120, ks=216, mh=158,
           sb=201, sf=229, gf=290, gb=319, tz=367, md=379, kb=358, tt=425 },
    bj = { bz=86, ar=118, mb=82, tn=89, ba=92, bj=0, jd=44, nb=142,
           zg=94, kf=74, ss=165, sl=74, ms=182, kr=144, ks=177, mh=217,
           sb=190, sf=263, gf=259, gb=328, tz=327, md=394, kb=338, tt=438 },
    jd = { bz=130, ar=133, mb=123, tn=129, ba=131, bj=44, jd=0, nb=175,
           zg=123, kf=36, ss=183, sl=70, ms=201, kr=150, ks=148, mh=233,
           sb=175, sf=265, gf=231, gb=315, tz=293, md=384, kb=312, tt=425 },
    nb = { bz=119, ar=66, mb=69, tn=63, ba=57, bj=142, jd=175, nb=0,
           zg=52, kf=183, ss=70, sl=129, ms=75, kr=103, ks=223, mh=109,
           sb=193, sf=190, gf=286, gb=291, tz=367, md=345, kb=345, tt=392 },
    zg = { bz=100, ar=52, mb=46, tn=45, ba=45, bj=94, jd=123, nb=52,
           zg=0, kf=131, ss=78, sl=79, ms=92, kr=81, ks=182, mh=129,
           sb=162, sf=193, gf=252, gb=280, tz=331, md=340, kb=319, tt=386 },
    kf = { bz=159, ar=152, mb=142, tn=148, ba=149, bj=74, jd=36, nb=183,
           zg=131, kf=0, ss=178, sl=60, ms=196, kr=137, ks=113, mh=225,
           sb=145, sf=245, gf=195, gb=286, tz=257, md=354, kb=277, tt=395 },
    ss = { bz=175, ar=122, mb=119, tn=116, ba=110, bj=165, jd=183, nb=70,
           zg=78, kf=178, ss=0, sl=118, ms=18, kr=52, ks=180, mh=52,
           sb=136, sf=121, gf=230, gb=221, tz=312, md=275, kb=281, tt=322 },
    sl = { bz=140, ar=114, mb=104, tn=108, ba=107, bj=74, jd=70, nb=129,
           zg=79, kf=60, ss=118, sl=0, ms=136, kr=80, ks=113, mh=166,
           sb=117, sf=196, gf=192, gb=254, tz=265, md=321, kb=267, tt=364 },
    ms = { bz=187, ar=133, mb=131, tn=128, ba=121, bj=182, jd=201, nb=75,
           zg=92, kf=196, ss=18, sl=136, ms=0, kr=67, ks=194, mh=37,
           sb=147, sf=116, gf=240, gb=221, tz=322, md=272, kb=287, tt=319 },
    kr = { bz=179, ar=132, mb=126, tn=126, ba=120, bj=144, jd=150, nb=103,
           zg=81, kf=137, ss=52, sl=80, ms=67, kr=0, ks=128, mh=89,
           sb=90, sf=120, gf=184, gb=199, tz=265, md=261, kb=242, tt=306 },
    ks = { bz=252, ar=225, mb=215, tn=219, ba=216, bj=177, jd=148, nb=223,
           zg=182, kf=113, ss=180, sl=113, ms=194, kr=128, ks=0, mh=206,
           sb=62, sf=182, gf=83, gb=185, tz=153, md=254, kb=163, tt=290 },
    mh = { bz=224, ar=170, mb=169, tn=165, ba=158, bj=217, jd=233, nb=109,
           zg=129, kf=225, ss=52, sl=166, ms=37, kr=89, ks=206, mh=0,
           sb=151, sf=89, gf=240, gb=200, tz=320, md=244, kb=277, tt=291 },
    sb = { bz=251, ar=212, mb=204, tn=205, ba=201, bj=190, jd=175, nb=193,
           zg=162, kf=145, ss=136, sl=117, ms=147, kr=90, ks=62, mh=151,
           sb=0, sf=120, gf=94, gb=141, tz=176, md=209, kb=156, tt=250 },
    sf = { bz=293, ar=241, mb=237, tn=235, ba=229, bj=263, jd=265, nb=190,
           zg=193, kf=245, ss=121, sl=196, ms=116, kr=120, ks=182, mh=89,
           sb=120, sf=0, gf=184, gb=112, tz=258, md=156, kb=201, tt=203 },
    gf = { bz=332, ar=300, mb=290, tn=293, ba=290, bj=259, jd=231, nb=286,
           zg=252, kf=195, ss=230, sl=192, ms=240, kr=184, ks=83, mh=240,
           sb=94, sf=184, gf=0, gb=137, tz=82, md=198, kb=82, tt=226 },
    gb = { bz=378, ar=331, mb=325, tn=325, ba=319, bj=328, jd=315, nb=291,
           zg=280, kf=286, ss=221, sl=254, ms=221, kr=199, ks=185, mh=200,
           sb=141, sf=112, gf=137, gb=0, tz=183, md=69, kb=108, tt=110 },
    tz = { bz=405, ar=377, mb=367, tn=370, ba=367, bj=327, jd=293, nb=367,
           zg=331, kf=257, ss=312, sl=265, ms=322, kr=265, ks=153, mh=320,
           sb=176, sf=258, gf=82, gb=183, tz=0, md=228, kb=81, tt=241 },
    md = { bz=440, ar=391, mb=386, tn=385, ba=379, bj=394, jd=384, nb=345,
           zg=340, kf=354, ss=275, sl=321, ms=272, kr=261, ks=254, mh=244,
           sb=209, sf=156, gf=198, gb=69, tz=228, md=0, kb=147, tt=47 },
    kb = { bz=405, ar=369, mb=360, tn=362, ba=358, bj=338, jd=312, nb=345,
           zg=319, kf=277, ss=281, sl=267, ms=287, kr=242, ks=163, mh=277,
           sb=156, sf=201, gf=82, gb=108, tz=81, md=147, kb=0, tt=162 },
    tt = { bz=486, ar=438, mb=432, tn=431, ba=425, bj=438, jd=425, nb=392,
           zg=386, kf=395, ss=322, sl=364, ms=319, kr=306, ks=290, mh=291,
           sb=250, sf=203, gf=226, gb=110, tz=241, md=47, kb=162, tt=0 } 
}

graphtn = {
    encoder = encoder,
    decoder = decoder,
    map = map,
    sld = sld
}
return graphtn
