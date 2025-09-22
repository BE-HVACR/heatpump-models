# heatpump-models
Simulation and analytical models of heat pump systems for performance evaluation and research.
This repository provides the **DXSystems** Modelica package, which includes fitted heat pump performance curve models.  
Currently, it contains a **water-to-air heat pump model**, with plans to expand to additional heat pump types.

---

## 📂 Repository Contents
- `DXSystems/` → Modelica package for direct expansion (DX) system components.
- Embedded heat pump performance curves.
- Example models demonstrating usage.

---

## 🔧 Dependencies
This package extends from libraries and requires the following versions:

- [Modelica Standard Library (MSL)](https://github.com/modelica/ModelicaStandardLibrary) v4.0.0  
- [Modelica Buildings Library](https://simulationresearch.lbl.gov/modelica/) v10.0.0  
- ModelicaServices v4.0.0  

Make sure these libraries are installed in your Modelica environment (e.g., Dymola, OpenModelica) before using.

---

## 🚀 Usage
1. Clone the repository:
   ```bash
   git clone https://github.com/BE-HVACR/heatpump-models.git
2. Place the DXSystems folder in your Modelica library path.

3. Open your Modelica tool (Dymola, OpenModelica, etc.).

4. Load DXSystems along with the required libraries.

5. Drag-and-drop the water-to-air heat pump model into your system simulation.

## 🛠 Roadmap
The current release includes:

- ✅ Water-to-air heat pump model

Planned additions:

- 🔄 Water-to-water heat pump

- 🔄 Air-to-water heat pump

- 🔄 Air-to-air heat pump

## 📖 Citation
If you use this repository or models in your research or applications, please cite:

Zhang, Yuhang, Mingzhe Liu, Zhiyao Yang, Caleb Calfa, and Zheng O’Neill.
Development and Validation of a Water-to-Air Heat Pump Model Using Modelica.
Modelica Conferences, pp. 119–126. 2024.

- APA style:

Zhang, Y., Liu, M., Yang, Z., Calfa, C., & O’Neill, Z. (2024). Development and Validation of a Water-to-Air Heat Pump Model Using Modelica. In Modelica Conferences (pp. 119–126).

## 📜 License
This repository is released under the MIT License.
You are free to use, modify, and distribute the models, provided that proper citation is given.

## 🤝 Contributing
Contributions are welcome!
If you’d like to:

- Add new heat pump types

- Improve performance curve fitting

- Extend example models

please open a pull request or submit issues for discussion.

## 🌐 Repository Link
https://github.com/BE-HVACR/heatpump-models
