INCLUDE=$($PYTHON -c "from sysconfig import get_paths;print(get_paths()['include'])")
echo $INCLUDE
ls $INCLUDE
locate boost
$PYTHON -m pip install . -vv --global-option --cmake-options="-DSTATIC_LINK_VW_JAVA=On;-DPython3_EXECUTABLE=\"$PYTHON\";-DPython_INCLUDE_DIR=\"$INCLUDE\""