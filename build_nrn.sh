#Script to build NEURON on MIC and x86 @ Stampede (Pramod Kumbhar, Michael Hines)
set -x

export CC=icc
export CXX=icpc
export MPICC=mpicc
export MPICXX=mpicxx

module purge all
module load intel/13.0.2.146 mvapich2

tag_dir=mvapich2_stampede

src_dir=`pwd`/$tag_dir
inst_dir=$HOME/install/$tag_dir

mkdir -p $inst_dir/mic
mkdir -p $inst_dir/x86
mkdir -p $src_dir

cd $src_dir

#clone master
hg clone http://www.neuron.yale.edu/hg/neuron/nrn
cd nrn

./build.sh

#first build for x86 target

./configure --without-iv --with-paranrn --with-x=no --with-memacs=no --enable-shared=yes --enable-pysetup=no --prefix=$inst_dir/x86
make -j12 install


#now build for MIC

module unload mvapich2
module load mvapich2-mic/20130911

make clean

./configure --without-iv --without-nmodl --with-paranrn --with-x=no --with-memacs=no --enable-shared=yes --enable-pysetup=no --prefix=$inst_dir/mic CXXFLAGS="-mmic -g" CFLAGS="-mmic -g"  --host=x86_64-k1om-linux

make VERBOSE=1   #this will fail due to nocmodl dependency, copy from previous installation for x86 (next line)

cp $inst_dir/x86/x86_64/bin/nocmodl src/nmodl/

make VERBOSE=1 install  #continue make & install


#copy x86 nocmodl to mic
cp $inst_dir/x86/x86_64/bin/nocmodl $inst_dir/mic/x86_64/bin/nocmodl

#remove funny libtool dependencies?
find $inst_dir/mic -type f -name "*.la" -print0 | xargs -0 sed -i 's/\/usr\/lib64\/..\/lib64\/libstdc++.la//g'
