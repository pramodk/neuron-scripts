Building Neuron (trunk) on Stampede system for x86 and MIC

1. first download and run build_nrn.sh script (change paths in the installation script appropriately) 
2. if you have set of mod files that you want to integrate / use, create libnrnmech.so file as: $install_dir_path/mic/x86_64/bin/nrnivmodl mod_files_dir/
3. Above command will create special exe and shared libraries. Set the bin and lib paths appropriately
