///UIDrawTaggedText(xp, yp, string, [opt] var);

/**
 * Tagged text does not support centering.
 *   TAGS:
 *      \cBBGGRR:
 *        Change text colour with a hexidecimal (HTML) colour. Format is BLUE:GREEN:RED, as opposed to RED:GREEN:BLUE
 *      \n:
 *        New Line Character
 *      \$:
 *        Variable
 *
**/

var xPos    = argument[0];
var yPos    = argument[1];
var strBase = argument[2];

var strLen  = string_length(argument[2]) + 1;

//Decode tags
var strParts;
var strNum     = 0;
var strStart   = 0;
var strPos     = 1;

var nextColour = c_white;
var strOffX = 0;
var strOffY = 0;

do {    
    strStart = strPos;
    while(string_char_at(strBase, strPos) != "\")
    {
        strPos++;
        
        if(strPos == strLen)
        {
            break;
        }
    }
    
    //Set String
    var strBuilder = array_create(4);
        strBuilder[0] = string_copy(strBase, strStart, (strPos-strStart));
        strBuilder[1] = nextColour;
        strBuilder[2] = strOffX;
        strBuilder[3] = strOffY;
        
    //Decode tag
    if(string_char_at(strBase, strPos) == "\")
    {
        switch(string_char_at(strBase, strPos+1))
        {
            //Colour Tag
            case 'c':
                nextColour = hex_to_dec(string_copy(strBase, strPos+2, 6));
                strPos = strPos + 8;
            break;
            
            //Line Break
            case 'n':
                strOffY += string_height("Y");
                strOffX  = -string_width(strBuilder[0]);
                strPos += 2;
            break;
            
            //Variable
            case '$':
                if(is_string(argument[3]))
                {
                    strBuilder[0] += argument[3];
                }else{
                    strBuilder[0] += string(argument[3]);
                }
                strPos += 2;
            break;
        }
    }
    
    strOffX += string_width(strBuilder[0]);
    
    strParts[strNum] = strBuilder;
    strNum++;
} until(strPos == strLen);

//Calculate Scaling with 1080p resolution as the constant.
var textScale = conUI.uiScale * 2;

//Draw Resulting strings
for(var i = 0; i < strNum; ++i)
{
    var strPart = strParts[i];
    draw_set_colour(strPart[1]);
    draw_text_transformed(xPos + (strPart[2] * textScale), yPos + (strPart[3] * textScale), strPart[0], textScale, textScale, 0);
}
draw_set_colour(c_white);
strParts = -1;

