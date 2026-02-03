# RAL_DMA_REGISTER_VERIFICATION

## Project Overview

This project focuses on UVM Register Abstraction Layer (RAL) based verification of a DMA configuration register. The objective is to validate correct behavior of register fields using frontdoor and backdoor accesses, and to ensure consistency between **DUT value, desired value, and mirrored value**.

The verification environment is built using UVM and checks different access combinations such as:

* Frontdoor Write / Frontdoor Read
* Backdoor Write / Backdoor Read
* Frontdoor Write / Backdoor Read
* Backdoor Write / Frontdoor Read


