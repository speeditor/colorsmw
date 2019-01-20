-- Error message datastore.
-- To extend this, populate the following:
--[[ 
    ["lang"] = {
        ["unparse"]       = "",
        ["invalid-param"] = "",
        ["invalid-value"] = "",
        ["invalid-type"]  = "",
        ["no-color"]      = "",
        ["no-data"]       = "",
        ["no-styling"]    = "",
        ["out-of-bounds"] = ""
    }
]]--
-- @version             2.5.0
-- @submodule
return {
    ["en"] = {
        ["unparse"]       = "cannot parse \"$1\"",
        ["invalid-param"] = "invalid SASS parameter name supplied",
        ["invalid-value"] = "invalid color value input: $1 \"$2\"",
        ["invalid-type"]  = "invalid color type \"$1\" specified",
        ["no-color"]      = "no color supplied",
        ["no-data"]       = "no color data provided",
        ["no-style"]      = "no styling supplied",
        ["out-of-bounds"] = "color value \"$1\" out of \"$2\" bounds"
    },
    ["be"] = {
        ["unparse"]       = "не можа распазнаць \"$1\"",
        ["invalid-param"] = "няслушнае імя параметра SASS",
        ["invalid-value"] = "няслушны ўвод значэння колеру: $1 \"$2\"",
        ["invalid-type"]  = "недапушчальны тып колеру \"$1\"",
        ["no-color"]      = "колер не падтрымваецца",
        ["no-data"]       = "не дадзеных пра колер",
        ["no-style"]      = "няма стылізацыі",
        ["out-of-bounds"] = "значэнне колеру \"$1\" за \"$2\" межамі"
    },
    ["fr"] = {
        ["unparse"]       = "impossible de parser \"$1\"",
        ["invalid-param"] = "le nom de paramètre SASS est invalide",
        ["invalid-value"] = "entrée de valeur de couleur invalide : $1 \"$2\"",
        ["invalid-type"]  = "le type de couleur \"$1\" n'est pas valide",
        ["no-color"]      = "aucune couleur n'a été donnée",
        ["no-data"]       = "aucune donnée de couleur n'a été donnée",
        ["no-style"]      = "aucun style n'a été donné",
        ["out-of-bounds"] = "la valeur de couleur \"$1\" est hors de \"$2\" limites"
    },
    ["ja"] = {
        ["unparse"]       = "\"$1\"をパースできないよ",
        ["invalid-param"] = "使えないSASSパラメータがあるよ",
        ["invalid-value"] = "無効な色のデータだよ: $1 \"$2\"",
        ["invalid-type"]  = "\"$1\"という名前のタイプは使えないよ",
        ["no-color"]      = "色のデータが入ってないよ",
        ["no-data"]       = "そんな名前の色のデータないよ",
        ["no-style"]      = "スタイリングのデータが入ってないよ",
        ["out-of-bounds"] = "\"$1\"が\"$2\"という境界をはみ出してるよ"
    },
    ["pl"] = {
        ["unparse"]       = "nie można zparsować \"$1\"",
        ["invalid-param"] = "wprowadzono nieprawidłową nazwę parametru SASS",
        ["invalid-value"] = "nieprawidłowa wartość koloru w: $1 \"$2\"",
        ["invalid-type"]  = "określono nieprawidłowy typ koloru \"$1\"",
        ["no-color"]      = "nie wprowadzono koloru",
        ["no-data"]       = "nie wprowadzono danych koloru",
        ["no-style"]      = "nie wprowadzono stylowania",
        ["out-of-bounds"] = "wartość koloru \"$1\" z \"$2\" granic"
    },
    ["ru"] = {
        ["unparse"]       = "не может распознать \"$1\"",
        ["invalid-param"] = "неверное имя параметра SASS",
        ["invalid-value"] = "неверный ввод значения цвета: $1 \"$2\"",
        ["invalid-type"]  = "недопустимый тип цвета \"$1\"",
        ["no-color"]      = "цвет не поддерживается",
        ["no-data"]       = "нет данных о цвете",
        ["no-style"]      = "нет стилизации",
        ["out-of-bounds"] = "значение цвета \"$1\" из \"$2\" границ"
    },
    ["uk"] = {
        ["unparse"]       = "не може проаналізувати \"$1\"",
        ["invalid-param"] = "недійсне ім\'я надаваного параметра SASS",
        ["invalid-value"] = "введенно неприпустиме значення кольору: $1 \"$2\"",
        ["invalid-type"]  = "вказано неправильний тип кольору \"$1\"",
        ["no-color"]      = "колір не підтримується",
        ["no-data"]       = "дані кольорів не надаються",
        ["no-style"]      = "відсутній стиль",
        ["out-of-bounds"] = "значення кольору \"$1\" за межами \"$2\""
    }
}
