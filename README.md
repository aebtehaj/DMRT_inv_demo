# Constrained Inversion of a Microwave Snowpack Emission Model Using Dictionary Matching: Applications for GPM Satellite
Ebtehaj A., M. Durand, M. Tedesco (2021), Constrained Inversion of a Microwave Snowpack Emission Model using Dictionary Matching: Applications for GPM Satellite, *IEEE Trans. on Geosci. and Remote Sens.*, 10.1109/TGRS.2021.3115663

This article presents a new algorithmic framework for multilayer inversion of the dense media radiative transfer (DMRT) equations of snowpack emission, with particular emphasis on the role of high-frequency microwave channels above 60 GHz. The approach relies on dictionary matching and locally constrained least squares. The results demonstrate that the algorithm can invert the DMRT model and retrieve depth, density, and grain size of a single-layer snowpack when dependencies of density and grain size on depth are properly accounted for. 

Locally Constrained Least-Squares Inversion of DMRT-QCA for Retrieval of Snowpack using Dictionary Matching.

<img width="400" alt="Screenshot 2022-12-13 at 4 11 16 PM" src="https://user-images.githubusercontent.com/46690843/207455125-415f6517-a7fa-4c72-bce8-8774a60039a8.png">

<img width="866" alt="Screenshot 2022-12-13 at 4 15 26 PM" src="https://user-images.githubusercontent.com/46690843/207456115-7563d85f-5254-4c8c-a663-b9cf9114e3f3.png">

**Figure.1** Randomized retrievals of depth $d$, density $\rho$ and grain size diameter $\delta$ using unconstrained classic nonlinear least-squares in (top row) and the introduced algorithm (bottom row). The observations are from forward simulations of the DMRT-QCA model at GMI frequency channels (10-166 GHz) in the absence of model and observation error -- assuming a single-layer representation of snowpack.



<img width="900" alt="Screenshot 2022-12-13 at 9 15 04 PM" src="https://user-images.githubusercontent.com/46690843/207496585-1887e178-d526-4e20-8855-1eceea0e6527.png">

**Figure.2** The level 1B horizontally polarized brightness temperatures from the GPM Microwave Imager (GMI) on February 13, 2020 (orbit # 033870) and the
extent of snow cover from the NOAA’s Automated Snow and Ice Mapping Product. Abbreviations of name of some states are shown on the top left panel.


<img height="200" alt="Screenshot 2022-12-13 at 9 22 03 PM" src="https://user-images.githubusercontent.com/46690843/207497440-ec3d8d32-ad2c-4169-85ad-bb45ca9c8ef4.png"><img height="195" alt="Screenshot 2022-12-13 at 9 24 10 PM" src="https://user-images.githubusercontent.com/46690843/207497695-afa47e4d-7d8c-4eb2-9612-a75693206f3c.png">

The inversion algorithm is provided in Demo_single_layer.m. 

