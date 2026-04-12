#!/bin/bash
# USAGE: This just loops through colours and template
# cd data then run it. It will overwrite Themes.css

######## INIT VARIABLES ########

stylesheet="Themes.css"
themes=("BLUEBERRY" "MINT" "LIME" "BANANA" "ORANGE" "STRAWBERRY" "BUBBLEGUM" "GRAPE" "COCOA" "SLATE" "LATTE" "SILVER" "BLACK")


######## SCRIPT ########

echo > $stylesheet
for accent_color in ${themes[*]};
do


cat << EOF >> $stylesheet

@define-color ACCENT_${accent_color} mix(@${accent_color}_500, @${accent_color}_700, 0.3);

window.${accent_color} {
    background-color: @${accent_color}_100;
}

window.${accent_color} undershoot.top {
    background:
        linear-gradient(
            @${accent_color}_100 0%,
            alpha(@${accent_color}_100, 0) 50%
        );
}

window.${accent_color} undershoot.bottom {
    background:
        linear-gradient(
            alpha(@${accent_color}_100, 0) 50%,
            @${accent_color}_100 100%
        );
}


/* WEIRD: if we dont personally just redefine overshoot effect, the grey theme doesnt have any*/
window.${accent_color} overshoot.top {
background: linear-gradient(to top, alpha(@ACCENT_${accent_color}, 0) 80%, alpha(@ACCENT_${accent_color}, 0.25) 100%); }

window.${accent_color} overshoot.right {
background: linear-gradient(to right, alpha(@ACCENT_${accent_color}, 0) 80%, alpha(@ACCENT_${accent_color}, 0.25) 100%); }

window.${accent_color} overshoot.bottom {
background: linear-gradient(to bottom, alpha(@ACCENT_${accent_color}, 0) 80%, alpha(@ACCENT_${accent_color}, 0.25) 100%); }

window.${accent_color} overshoot.left {
background: linear-gradient(to left, alpha(@ACCENT_${accent_color}, 0) 80%, alpha(@ACCENT_${accent_color}, 0.25) 100%); }

window.${accent_color} text selection {
    color: shade(@${accent_color}_100, 1.88);
    background-color: @${accent_color}_900;
}

window.${accent_color} titlebar,
window.${accent_color} titlebar image,
window.${accent_color} .themedbutton > button > box > image,
window.${accent_color} .themedbutton > image,
window.${accent_color} {
    color: @${accent_color}_900;
}

window.${accent_color} titlebar,
window.${accent_color} textview,
window.${accent_color} editablelabel.editing {
    background-color: transparent;
    border-bottom-color: @${accent_color}_100;
    color: shade(@${accent_color}_900, 0.77);
}

/* Fix the emoticon entry having note color background */
window.${accent_color} entry {
    background-color: white;
    color: black;
}

window.${accent_color} editablelabel {
    color: @${accent_color}_900;
}

window.${accent_color} editablelabel:hover,
window.${accent_color} editablelabel:focus {
    border: 1px solid alpha(@ACCENT_${accent_color},0.88);
}

window.${accent_color} editablelabel.editing {
    border: 1px solid @${accent_color}_700;
}

window.${accent_color}:backdrop editablelabel {
    color: alpha(@${accent_color}_900, 0.75);
}

window.${accent_color}:backdrop editablelabel,
window.${accent_color}:backdrop actionbar,
window.${accent_color}:backdrop actionbar image {
    color: alpha(@${accent_color}_900, 0.65);
}

EOF

done