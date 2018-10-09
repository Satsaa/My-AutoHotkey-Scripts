;Cross use functions

;#####################################################################################
;Conversions
MsgBox(SimilarityScore("Banana", "Banana"))

HexToDec(hexVal){  ;Base 16 to base 10
	Return hexVal
}

;RGBToHex(Red,Green,Blue){ ;not v2 converted
;	oldIntFormat := A_FormatInteger
;	SetFormat, IntegerFast, hex
;	RGB := subStr("0" subStr(Red & 255, 3), -1)
;	. subStr("0" subStr(Green & 255, 3), -1)
;	. subStr("0" subStr(Blue & 255, 3), -1)
;	SetFormat, IntegerFast, %oldIntFormat%
;	return RGB
;}

;#####################################################################################
;Returns boolean. Compares if color in x,y is one in the Colors*  

CompareColor(x,y,Colors*){
	pixelColor := PixelGetColor(X, Y , Mode)
	for i, color in Colors
		if (color=pixelColor)
			Return 1
	Return 0
}

;#####################################################################################
;Gives a similarity score for string A and B


SimilarityScore(stringA, stringB){
	score := 0, searchLength := 0, lengthA := StrLen(stringA), lengthB := StrLen(stringB)
	Loop (lengthA < lengthB ? lengthA : lengthB) * 2 {
		If Mod(A_Index, 2)
			searchLength += 1, needle := "A", haystack := "B"
		Else needle := "B", haystack := "A"
		startAtHaystack := 1, startAtNeedle := 1
		While (startAtNeedle + searchLength <= length%Needle% + 1) {
			searchText := SubStr(string%Needle%, startAtNeedle, searchLength)
			If (pos := InStr(string%Haystack%, searchText, 0, startAtHaystack)) {
				startAtHaystack := pos + searchLength, startAtNeedle += searchLength, score += searchLength**2
				If (startAtHaystack + searchLength > Length%Haystack% + 1)
					Break
			} Else startAtNeedle += 1
	}} Return score / (lengthA > lengthB ? lengthA : lengthB)
}
