'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "68bdc25f9a8bb9f1ebdbb94204081ee5",
"assets/AssetManifest.bin.json": "266bc1c763c7eb524f4a05363f761c9b",
"assets/AssetManifest.json": "5f95ec1b57df60463e1b9d3c5603a922",
"assets/assets/icons/hires-11.png": "dfd3ee60edf0e7a8cbd7530075ae8ef3",
"assets/assets/icons/icon-000.png": "cf55676a87a83d6ef7f24e3c54165f00",
"assets/assets/icons/icon-001.png": "2e5ed5691fa24565648fa330911a536c",
"assets/assets/icons/icon-002.png": "357803e153ae6d502a04ceea964e369f",
"assets/assets/icons/icon-003.png": "c93da3799d98454e7cddd0a685e7d493",
"assets/assets/icons/icon-004.png": "b327aeaee7f0adc41e8fe64de4d24e1a",
"assets/assets/icons/icon-005.png": "3495cfdd07d47925be3d00ab9916ff7f",
"assets/assets/icons/icon-006.png": "327667e8ffbda66025ce832938263f42",
"assets/assets/icons/icon-007.png": "df14de3d958d7315e126582e8795ff66",
"assets/assets/icons/icon-008.png": "4d3b4e70d3307d888a0ed9919a58ce51",
"assets/assets/icons/icon-009.png": "8a6c1bb54f972ad817c4590268fdc65d",
"assets/assets/icons/icon-010.png": "5933e4e25ee6e8f3e68014e63c09de42",
"assets/assets/icons/icon-011.png": "f5990c291e78839f0a6583bc7ebb7a62",
"assets/assets/icons/icon-012.png": "c2e58812cd572d6a55916b606395e655",
"assets/assets/icons/icon-013.png": "6409732e41bc0ba949740d7f1fc4d2f4",
"assets/assets/icons/icon-014.png": "5d0c72ebe764bfae8f78fa260007a489",
"assets/assets/icons/icon-015.png": "7bd2ef7ff4088fc8bdf39c8aaca18004",
"assets/assets/icons/icon-016.png": "8408297380882952503403ed8565b58b",
"assets/assets/icons/icon-017.png": "54016e22c1639d4c727f5d870f775bf9",
"assets/assets/icons/icon-018.png": "bb867bfd393b2408a61b873eeb5330f4",
"assets/assets/icons/icon-019.png": "912f8a0c51941954e1cf3411d08a6cbf",
"assets/assets/icons/icon-020.png": "7fe53cd5e39dff9d848b178d3cfda4a0",
"assets/assets/icons/icon-021.png": "bde8c536a86f933301e469518778c346",
"assets/assets/icons/icon-022.png": "9d6e7e95afaa112fe5553649471bf2d7",
"assets/assets/icons/icon-023.png": "ef263ec8440404581b15d4d804faca1d",
"assets/assets/icons/icon-024.png": "52841f290e292d0eeced41fb324b128e",
"assets/assets/icons/icon-025.png": "9f6cc32e11ec06453ed86f3e76313749",
"assets/assets/icons/icon-026.png": "d52541250bc2a4e27d16af083430f20f",
"assets/assets/icons/icon-027.png": "64e1e9df204d82230d090f83cba17fb4",
"assets/assets/icons/icon-028.png": "de85e8821368a44c6d61d5ce2dc7dcaa",
"assets/assets/icons/icon-029.png": "0b9f8efe95cfa77944a9077843900c58",
"assets/assets/icons/icon-030.png": "c5972f0329a9f94addf013a47eb2ec3a",
"assets/assets/icons/icon-031.png": "dbc5476f1a084527ef3b6fc72eee9b54",
"assets/assets/icons/icon-032.png": "38ce73a6d441992f02c4f7935870e02d",
"assets/assets/icons/icon-033.png": "09d89397d328c649e353690df250c5dc",
"assets/assets/icons/icon-034.png": "dbbc9a2bef1caf33a58b6ec9145aa117",
"assets/assets/icons/icon-035.png": "62c5b0afa9f48248e2410ddf14aaf5bc",
"assets/assets/icons/icon-036.png": "f98a3e4067ea06ca05949a5ddfeb96ab",
"assets/assets/icons/icon-037.png": "7f1678bccd11a41409fa75892ab90ac3",
"assets/assets/icons/icon-038.png": "d9a2d4ecda7cdf7a6ce978f1d6fe9f0b",
"assets/assets/icons/icon-039.png": "20b99541581d7db110a761d7806b952d",
"assets/assets/icons/icon-040.png": "1fb9abc48a7f968cdc83921c40136588",
"assets/assets/icons/icon-041.png": "00c4b0f907004e4f110ce3c957f1b6b1",
"assets/assets/icons/icon-042.png": "b8cc14b4f2a06d37636247a53d5b5ad8",
"assets/assets/icons/icon-043.png": "0f9ebdad98316717c263b66d280c8eea",
"assets/assets/icons/icon-044.png": "a4634e85a5dbdd58b033195ce50aaed6",
"assets/assets/icons/icon-045.png": "c5dd6a7d13f6739ea7c803f01c19485a",
"assets/assets/icons/icon-046.png": "f452e3574f25c42191c6a868e41d175d",
"assets/assets/icons/icon-047.png": "cf8622ccb222cf6ba65e455c3252c2b0",
"assets/assets/icons/icon-048.png": "ba31c18ca02605fbc13105fc2eb32fe9",
"assets/assets/icons/icon-049.png": "e897db1ea70955997044b7f2f9158c4d",
"assets/assets/icons/icon-050.png": "0bc3e5dabb9f282f851326b92d154a62",
"assets/assets/icons/icon-051.png": "608ff8fe85395146cfc252a79e28847b",
"assets/assets/icons/icon-052.png": "c94452fec3a59317c5549f6ebfec70a5",
"assets/assets/icons/icon-053.png": "13cb9617b66c6aad1c533ac4bb0a50b4",
"assets/assets/icons/icon-054.png": "f19368902d88a0751b9910de0ea20565",
"assets/assets/icons/icon-055.png": "fa002aa76010de6b6dff2b84d4e6a42a",
"assets/assets/icons/icon-056.png": "b4e62b21a6bdcb7296f4d514724c93e0",
"assets/assets/icons/icon-057.png": "79b4d126df70aac5afb5e91f185adbf7",
"assets/assets/icons/icon-058.png": "9374d6256b462fb10f9544f8ba9523da",
"assets/assets/icons/icon-059.png": "46955c4a18b6065a43e912c884441df6",
"assets/assets/icons/icon-060.png": "6d507ca6b8e315d1e64d88707cf3fcc8",
"assets/assets/icons/icon-061.png": "8c9a480c1815fb72e430adaf69ea5ec4",
"assets/assets/icons/icon-062.png": "33e81116de9adcfb877bf62604ee8c95",
"assets/assets/icons/icon-063.png": "8c320b9a0c212b3e763dad9c77c7d09c",
"assets/assets/icons/icon-064.png": "ae01dfea87bd28f687b707f9cd26d0c0",
"assets/assets/icons/icon-065.png": "1a41569deeb8d77b8f6b72a0bf6221e7",
"assets/assets/icons/icon-066.png": "15da59ba9c408ee80ba311d977ab2bf8",
"assets/assets/icons/icon-067.png": "caf77140a2f6cf3c4fe6645dc504fd64",
"assets/assets/icons/icon-068.png": "ba28809fb98e86211c62d44cad8c8a2e",
"assets/assets/icons/icon-069.png": "deda46619b5eb93345948ba4e796edb6",
"assets/assets/icons/icon-070.png": "0904afc11b1df52d3515b5ceeeaf9065",
"assets/assets/icons/icon-071.png": "fe7ec42cfbfb55c1fb9903b78e1009be",
"assets/assets/icons/icon-072.png": "22dcad56e4bae09a069c1b11bc6473f2",
"assets/assets/icons/icon-073.png": "f1ca5bce1815c1ad8463f45f08b42dba",
"assets/assets/icons/icon-074.png": "cce5a9bfde23af07e09fe2812f4ed411",
"assets/assets/icons/icon-075.png": "45fe44738e474592376d3c62432cad1f",
"assets/assets/icons/icon-076.png": "ee9a65ec667dbbb58d6bf7ee147d7d17",
"assets/assets/icons/icon-077.png": "4eddf22a6b71070a55578a6df7d9a203",
"assets/assets/icons/icon-078.png": "fa6d011d0034c83f8fe6db50a9b06809",
"assets/assets/icons/icon-079.png": "e271cf35d06b83ab3c6eb0e04c2d262c",
"assets/assets/icons/icon-080.png": "6fec5db6b3a59331532c3f7286b9a296",
"assets/assets/icons/icon-081.png": "7af936d2707003a2a2d3233fb5d643d6",
"assets/assets/icons/icon-082.png": "6ff2eeb7acbdee2d8b617fdda15be19a",
"assets/assets/icons/icon-083.png": "f1c5a51c6efdb1e84e1deb012cba6c90",
"assets/assets/icons/icon-084.png": "7408e29b1d062bb15e0f58da3955688d",
"assets/assets/icons/icon-085.png": "612ca763a9f557c466969bf9a2a3e7ea",
"assets/assets/icons/icon-086.png": "14cab0f80f749f9b1f6ec642839e362d",
"assets/assets/icons/icon-087.png": "e94deff8bd5efce0e45bcd3c6863aac2",
"assets/assets/icons/icon-088.png": "4bc6af2e8dd8b4d2de37f20d27767c5d",
"assets/assets/icons/icon-089.png": "a73a3c143c37a35c95b0f508378a88af",
"assets/assets/icons/icon-090.png": "446d483fc45373ce1ec8aa8dc1985894",
"assets/assets/icons/icon-091.png": "f4ae28c1729e4d270b90b521549cf83b",
"assets/assets/icons/icon-092.png": "1267a7ebb16e614dcd8ae5cfcd722c09",
"assets/assets/icons/icon-093.png": "c38c53977a48c49573ad6b70cb5267a8",
"assets/assets/icons/icon-094.png": "046884f4fb5276308b234e6ab42f0f4c",
"assets/assets/icons/icon-095.png": "fe659093de2a52b7caecea21229fe3cd",
"assets/assets/icons/icon-096.png": "7d143dd8516c7c1dc4b0ad95218ca363",
"assets/assets/icons/icon-097.png": "ff5b05d4efbace01bd3c9658a1b5b2f0",
"assets/assets/icons/icon-098.png": "53a536b07d248ecc2ffa97a6625a3792",
"assets/assets/icons/icon-099.png": "85c2417c40b67b2c7aef241410db1459",
"assets/assets/icons/icon-100.png": "c453ff5871e92f5693c3cd16667d2c54",
"assets/assets/icons/icon-101.png": "06b9cefc150d6707c68c9fdb7ce143e1",
"assets/assets/icons/icon-102.png": "45a166a542bb54c8bb1ed672afd3b76a",
"assets/assets/icons/icon-103.png": "d894f2b4a324d40823bb15728e6c84b4",
"assets/assets/icons/icon-104.png": "b21428bb4d12246535c0f8679b691bb8",
"assets/assets/icons/icon-105.png": "d83993fdc4dd3fefcfb561c2db92b948",
"assets/assets/icons/icon-106.png": "399a554e2e1d9e7b358c7dc471fe75d9",
"assets/assets/icons/icon-107.png": "3742ee3c0ffb591bca196a85e914aa10",
"assets/assets/icons/icon-108.png": "98b2dfd7cf18be1ffe3ce0a80db61987",
"assets/assets/icons/icon-109.png": "c27b36c6b04faf1dcd24cd40ba9cb9d0",
"assets/assets/icons/icon-110.png": "2ed6a88baa375508d90545c087d95ae0",
"assets/assets/icons/icon-111.png": "4dc913e5ad8e0289c45fd7c6b0e1aa7c",
"assets/assets/icons/icon-112.png": "da12a014065379ba358e697b6a07ae9b",
"assets/assets/icons/icon-113.png": "30680bc7b2b83ccf1c0cab9d53c9f500",
"assets/assets/icons/icon-114.png": "e62238164ac44a2a538b2d382421fe01",
"assets/assets/icons/icon-115.png": "60d1a6a64d9a05ececf2a69179e0ac83",
"assets/assets/icons/icon-116.png": "14ba4f0bb4f2c9013caa6059449ba56c",
"assets/assets/icons/icon-117.png": "2c114c4230acb3892a17a55cb32bff35",
"assets/assets/icons/icon-118.png": "ba2fc50960ebc9281df014dc2d042cda",
"assets/assets/icons/icon-119.png": "e87e7581ae597872390f58049c3cb107",
"assets/assets/icons/icon-120.png": "dbac56e472bb60989ba41e69f1949533",
"assets/assets/icons/icon-121.png": "68f27baf53282c162ea6c0be28baeefa",
"assets/assets/icons/icon-122.png": "a992e29b5679d085a16a2029d6d4f85c",
"assets/assets/icons/icon-123.png": "ba92870012750b8d436534cdbc60de4e",
"assets/assets/icons/icon-124.png": "59ccde5adbfdc4a486bc409922c12a93",
"assets/assets/icons/icon-125.png": "d7b643261b3d55ca1d4cc077e9f5e97b",
"assets/assets/icons/icon-126.png": "85923b9d79b8451b034b0c149b45d1d2",
"assets/assets/icons/icon-127.png": "68616900742504b43d695800ad730c7b",
"assets/assets/icons/icon-128.png": "c1996ce320567ec17005e25320270ee6",
"assets/assets/icons/icon-129.png": "d334ca6237af4711277e5f9bcbdfae6a",
"assets/assets/icons/icon-130.png": "80a31b646c9b62241c931b5c78a0b290",
"assets/assets/icons/icon-131.png": "6f129c4f2ffe38971d29f4459f76cade",
"assets/assets/icons/icon-132.png": "66ab1c4e5033a167f2a081e16c98db9e",
"assets/assets/icons/icon-133.png": "c69b36475c3e1029d06c3611d350e5a5",
"assets/assets/icons/icon-134.png": "1604bd60e319f88028b6566c620d6f0a",
"assets/assets/icons/icon-135.png": "1d36ab64e86de25963d915a446e652b9",
"assets/assets/icons/icon-136.png": "27fa3c3085bdeaec75314672f236bae3",
"assets/assets/icons/icon-137.png": "2310d5dbdc417c0f593d082b35b1e85f",
"assets/assets/icons/icon-138.png": "cc6759bcffbb9550e2167d39e0f1b07d",
"assets/assets/icons/icon-139.png": "cc5907700d8160a84f81dd9614140d9d",
"assets/assets/icons/icon-140.png": "aeea93d336f45371c4ccec4415bc8f80",
"assets/assets/icons/icon-141.png": "d139ea24090f091d84c7dd274c9d68db",
"assets/assets/icons/kw_action.png": "84a6c8ba871f174fc8ab04c1b1ebc9a4",
"assets/assets/icons/kw_armour.png": "d3aa8323fab248e4fa052ba96edc7233",
"assets/assets/icons/kw_blast.png": "b9a45f1956d921fe9b497e324922f418",
"assets/assets/icons/kw_blessed.png": "3fbf07b8bafb54f33adf06dcc782e970",
"assets/assets/icons/kw_bludgeoning.png": "4d3b4e70d3307d888a0ed9919a58ce51",
"assets/assets/icons/kw_burning.png": "27c7e1ff5f9ca8cad5b1612325365bda",
"assets/assets/icons/kw_cleave.png": "7fe53cd5e39dff9d848b178d3cfda4a0",
"assets/assets/icons/kw_cursed.png": "de85e8821368a44c6d61d5ce2dc7dcaa",
"assets/assets/icons/kw_effortless.png": "7919df679f3d71f81ef1ca733aa00aee",
"assets/assets/icons/kw_entangling.png": "f98a3e4067ea06ca05949a5ddfeb96ab",
"assets/assets/icons/kw_fast.png": "30b532186f53be0ad22db8f78af9fdfc",
"assets/assets/icons/kw_fatigued.png": "2b5926072f1811d9adafbb48618251f0",
"assets/assets/icons/kw_first_strike.png": "0224bc00623643d6c2184a4706cd1b17",
"assets/assets/icons/kw_hawkeye.png": "1fb9abc48a7f968cdc83921c40136588",
"assets/assets/icons/kw_immunity.png": "0bc3e5dabb9f282f851326b92d154a62",
"assets/assets/icons/kw_piercing.png": "7408e29b1d062bb15e0f58da3955688d",
"assets/assets/icons/kw_poisoned.png": "eb9c22d921c66456dd28d9a488343cf3",
"assets/assets/icons/kw_quickstrike.png": "046884f4fb5276308b234e6ab42f0f4c",
"assets/assets/icons/kw_reach.png": "98b2dfd7cf18be1ffe3ce0a80db61987",
"assets/assets/icons/kw_reactive.png": "53a536b07d248ecc2ffa97a6625a3792",
"assets/assets/icons/kw_regeneration.png": "c453ff5871e92f5693c3cd16667d2c54",
"assets/assets/icons/kw_relentless.png": "45a166a542bb54c8bb1ed672afd3b76a",
"assets/assets/icons/kw_sharp.png": "14ba4f0bb4f2c9013caa6059449ba56c",
"assets/assets/icons/kw_stunned.png": "59fe42ef3d452012eff4835ede3af03b",
"assets/assets/icons/kw_terrified.png": "5211832939faf64de50c9f3399e1c54f",
"assets/assets/icons/kw_terrifying.png": "85923b9d79b8451b034b0c149b45d1d2",
"assets/assets/icons/kw_unarmed_combat.png": "dbac56e472bb60989ba41e69f1949533",
"assets/assets/icons/kw_vicious.png": "27fa3c3085bdeaec75314672f236bae3",
"assets/assets/icons/kw_warded.png": "0efc465492b30cffa46fbeffd8b4b7d2",
"assets/assets/icons/kw_wounded.png": "5431ca133ae5c2fb3b706d19f2e9c885",
"assets/assets/icons/p3-000.png": "cf55676a87a83d6ef7f24e3c54165f00",
"assets/assets/icons/p3-001.png": "2e5ed5691fa24565648fa330911a536c",
"assets/assets/icons/p3-002.png": "84a6c8ba871f174fc8ab04c1b1ebc9a4",
"assets/assets/icons/p3-003.png": "0aef351f79cfcd2893c2aceeca651f4b",
"assets/assets/icons/p3-004.png": "f9b83ae62130fbe3ada8328b51b0ecd4",
"assets/assets/icons/p3-005.png": "c114bcaaf56490d8ff7c2b13eb98fe4a",
"assets/assets/icons/p45-000.png": "cf55676a87a83d6ef7f24e3c54165f00",
"assets/assets/icons/p45-001.png": "2e5ed5691fa24565648fa330911a536c",
"assets/assets/icons/p45-002.png": "cf55676a87a83d6ef7f24e3c54165f00",
"assets/assets/icons/p45-003.png": "2e5ed5691fa24565648fa330911a536c",
"assets/assets/icons/p45-004.png": "8d4b200cf9b71120daa1d3954ecffe25",
"assets/assets/icons/p45-005.png": "c393589ea557f809bf7b5c4733d57f3c",
"assets/assets/icons/p45-006.png": "dd87a3457b4653006cb323f64bfa4ca5",
"assets/assets/icons/p45-007.png": "399c0fb1564f90f3a746356e9e7c8871",
"assets/assets/icons/p45-008.png": "bccb5c12265cb080b67c1806b882b3df",
"assets/assets/icons/p45-009.png": "1d9188981c134bb8b08644b2fae834b7",
"assets/assets/icons/p45-010.png": "7ecaf3d5a6821616c9ae3a0ef9708ea5",
"assets/assets/icons/p45-011.png": "0aef351f79cfcd2893c2aceeca651f4b",
"assets/assets/icons/page-08.png": "e98a9114327e8654207cd63359a86281",
"assets/assets/icons/page-09.png": "a338aa004292bb68313da7f63666c6e7",
"assets/assets/icons/page-10.png": "509ca4008f7a20744f984031a013fa56",
"assets/assets/icons/page-11.png": "c4d2f4d4a182c5c522a11ae33d390384",
"assets/assets/icons/pg-01.png": "639a9b38016474b3934b60349c06b7c8",
"assets/assets/icons/pg-02.png": "17cfc1cf83860ca34ff8b03aea068d9e",
"assets/assets/icons/pg-03.png": "d2cbd370fd3503fd5a9f9213779fba65",
"assets/assets/icons/pg-04.png": "cfb072a1748321ebf728c2f9cee4a2e7",
"assets/assets/icons/pg-05.png": "9d8c74c9329b7ddd699ba5aa74125e47",
"assets/assets/icons/pg-06.png": "6ec6263082e0d24c9e713d899dd12d55",
"assets/assets/icons/pg-07.png": "15d42d4c5ce2c57cd8e8ee8fe90445a7",
"assets/assets/icons/pg-08.png": "97eeef3a2e99aedd375bd74cb0a11090",
"assets/assets/icons/pg-09.png": "c0528e9674d96ba0462926e54344ab47",
"assets/assets/icons/se-000.png": "a1f970b10da3fc25ce159aeb5a35c678",
"assets/assets/icons/se-001.png": "70208d67f9cf199e82ae8b78f81893ff",
"assets/assets/icons/se-002.png": "a1f970b10da3fc25ce159aeb5a35c678",
"assets/assets/icons/se-003.png": "70208d67f9cf199e82ae8b78f81893ff",
"assets/assets/icons/se-004.png": "3fbf07b8bafb54f33adf06dcc782e970",
"assets/assets/icons/se-005.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-006.png": "27c7e1ff5f9ca8cad5b1612325365bda",
"assets/assets/icons/se-007.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-008.png": "46c6da031fd06aea85a2fc4c7f9ed3ce",
"assets/assets/icons/se-009.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-010.png": "2b5926072f1811d9adafbb48618251f0",
"assets/assets/icons/se-011.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-012.png": "eb9c22d921c66456dd28d9a488343cf3",
"assets/assets/icons/se-013.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-014.png": "59fe42ef3d452012eff4835ede3af03b",
"assets/assets/icons/se-015.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-016.png": "5211832939faf64de50c9f3399e1c54f",
"assets/assets/icons/se-017.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-018.png": "0efc465492b30cffa46fbeffd8b4b7d2",
"assets/assets/icons/se-019.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-020.png": "5431ca133ae5c2fb3b706d19f2e9c885",
"assets/assets/icons/se-021.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-022.png": "3fbf07b8bafb54f33adf06dcc782e970",
"assets/assets/icons/se-023.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-024.png": "27c7e1ff5f9ca8cad5b1612325365bda",
"assets/assets/icons/se-025.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-026.png": "46c6da031fd06aea85a2fc4c7f9ed3ce",
"assets/assets/icons/se-027.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-028.png": "2b5926072f1811d9adafbb48618251f0",
"assets/assets/icons/se-029.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-030.png": "eb9c22d921c66456dd28d9a488343cf3",
"assets/assets/icons/se-031.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-032.png": "59fe42ef3d452012eff4835ede3af03b",
"assets/assets/icons/se-033.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-034.png": "5211832939faf64de50c9f3399e1c54f",
"assets/assets/icons/se-035.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-036.png": "0efc465492b30cffa46fbeffd8b4b7d2",
"assets/assets/icons/se-037.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/assets/icons/se-038.png": "5431ca133ae5c2fb3b706d19f2e9c885",
"assets/assets/icons/se-039.png": "2650c48b0a84c898601b97fa16c8b0d8",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "fb82a6bd4de21d223a15d59caa03dc1e",
"assets/NOTICES": "adde0c761512f10ae0d1e47dde06b2ea",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "5fcf8f04749db25a86e92fd0d77bd619",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "9af580833d2f602d1834fc2b7bba10cf",
"/": "9af580833d2f602d1834fc2b7bba10cf",
"main.dart.js": "b449cb7aee69d692b26af663d632e715",
"manifest.json": "be0250b40da6c06d9042b0b629a6174c",
"version.json": "549ee9a94cd0540719b3a0f9d450ebba"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
