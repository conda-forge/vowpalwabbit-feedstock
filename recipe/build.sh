#!/bin/env bash

# get the proper ext_suffix:
EXT_NAME_DIRTY="$(python -m sysconfig | grep "EXT_SUFFIX =")"
EXT_NAME_CLEAN=${EXT_NAME_DIRTY:15:200}
EXT_NAME=${EXT_NAME_CLEAN%?}

# get the python inc dir
PYTHON_INC_PATH_EDIT=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")

# make a build dir
rm -rf build; mkdir build; cd build

# flatbuffers seems to cause a problem, not sure why?
# need pyver with dot formatted

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

cmake .. \
          -DRAPIDJSON_SYS_DEP=ON \
          -DFMT_SYS_DEP=ON \
          -DSPDLOG_SYS_DEP=ON \
          -DBUILD_FLATBUFFERS=Off \
          -DBUILD_PYTHON=On \
          -DPY_VERSION="${CONDA_PY:0:1}.${CONDA_PY:1:2}" \
          -DCMAKE_INSTALL_PREFIX=$PREFIX \
          -DBUILD_TESTS=Off \
          -DCMAKE_LIBRARY_OUTPUT_DIRECTORY=$SP_DIR \
          -DCMAKE_PREFIX_PATH=$CONDA_PREFIX \
          -DBoost_NO_BOOST_CMAKE=ON \
          -DVW_PYTHON_SHARED_LIB_SUFFIX=$EXT_NAME \
          -DPython_INCLUDE_DIR=$PYTHON_INC_PATH_EDIT \
          $CMAKE_ARGS

cmake --build . -j${CPU_COUNT}
cmake --install .

cd ..

# since the pylibvw library has been installed already
# don't try to reinstall it again
sed -i.bak '/\"build\_ext\"/d' setup.py

$PYTHON setup.py install

