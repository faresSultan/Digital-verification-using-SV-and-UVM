
package config_obj_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class alsu_config extends uvm_object;
        `uvm_object_utils(alsu_config)

        uvm_active_passive_enum is_active;

        virtual ALSU_if alsu_config_if;

        function new(string name = "alsu_config_obj");
            super.new(name);
        endfunction 
    endclass 
    
endpackage

