within DXSystems.Reversible.WaterSource.Examples;
model VariableSpeedTest "Test model for variable speed DX coil"

  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoiCoo.sta[datCoiCoo.nSta].nomVal.m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal=1000
    "Pressure drop at m_flow_nominal";
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal=40000
    "Pressure drop at mCon_flow_nominal";
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(final min=0) = 8880
    "Nominal heating capacity (positive number)";
  parameter Modelica.Units.SI.HeatFlowRate QCoo_flow_nominal(final max=0) = -7210
    "Nominal cooling capacity (negative number)";
  parameter Real ratioHea = QHea_flow_nominal/8880
                             "Scaling factor for heating capacity";
  parameter Real ratioCoo = abs(QCoo_flow_nominal/7210)
                             "Scaling factor for cooling capacity";

  parameter Real speRat = 1 "Speed ratio";
  parameter Integer uMod = -1
    "Control input signal, cooling mode=-1, off=0, heating mode=+1";
  parameter Modelica.Units.SI.MassFlowRate mLoa_flow_in = 0.515 "Prescribed mass flow rate";
  parameter Modelica.Units.SI.Temperature TLoa_in = 273.15 + 23 "Prescribed boundary temperature";
  parameter Modelica.Units.SI.MassFlowRate mSou_flow_in = 0.39 "Prescribed mass flow rate";
  parameter Modelica.Units.SI.Temperature TSou_in = 273.15 +25  "Prescribed boundary temperature";
  parameter Real xLoa_flow_in = 0.01 "Speed ratio";

  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumAir,
    p(displayUnit="Pa"),
    nPorts=1)            "Sink on air side"
    annotation (Placement(transformation(extent={{52,30},{32,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T souAir(
    redeclare package Medium = MediumAir,
    use_Xi_in=true,
    m_flow=mLoa_flow_in,
    T=TLoa_in,
    nPorts=1) "Source on air side"
    annotation (Placement(transformation(extent={{-48,28},{-28,48}})));

  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWater,
    m_flow=mSou_flow_in,
    use_T_in=false,
    use_m_flow_in=false,
    T=TSou_in,
    nPorts=1) "Source on water side"
    annotation (Placement(transformation(extent={{40,-60},{20,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWater,
    p(displayUnit="Pa"),
    nPorts=1)            "Sink on water side"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  VariableSpeedReversible heaPum(
    datCoi=datCoiCoo,
    datCoiHea=datCoiHea,
    redeclare package MediumEva = MediumAir,
    redeclare package MediumCon = MediumWater,
    dpEva_nominal=dpEva_nominal,
    dpCon_nominal=dpCon_nominal,
    minSpeRat=datCoiCoo.minSpeRat)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.IntegerConstant operMode(k=uMod)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  parameter Data.VSV024Hea2 datCoiHea(sta={
        DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=3000,
        nomVal=
          DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=8880*ratioHea,
          COP_nominal=6.1,
          SHR_nominal=1,
          m_flow_nominal=1.2*0.4389*ratioHea,
          mCon_flow_nominal=1000*0.00039*ratioHea),
        perCur=
          DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.45925536518299437,-0.0013050734028837387,-1.9016543203276734e-05,
            0.019007443407759506,4.27609060417566e-05,-0.00014476326504573624},
          capFunFF={0.8935464784714185,0.1463060691424797},
          capFunFFCon={0.921263331209476,0.07482000317225788},
          EIRFunT={0.7265333330040449,0.02699495099091462,0.0002512997610790123,
            -0.01599841860831001,0.00032480273429471906,-0.0005880564607380053},
          EIRFunFF={1.3971413743639551,-0.5455600880724918},
          EIRFunFFCon={1.0508215548811073,-0.04808022202954253},
          TConInMin=273.15 - 3.89,
          TConInMax=273.15 + 29.44,
          TEvaInMin=273.15 + 18.33,
          TEvaInMax=273.15 + 32.22,
          ffMin=0.875,
          ffMax=1.125,
          ffConMin=0.875,
          ffConMax=1.125))})          annotation (Placement(transformation(extent={{20,60},{40,80}})));
  parameter Data.VSV024Coo2 datCoiCoo(sta={
        DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=3000,
        nomVal=
          DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-7210*ratioCoo,
          COP_nominal=5.4,
          SHR_nominal=0.82,
          m_flow_nominal=1.2*0.4389*ratioCoo,
          mCon_flow_nominal=1000*0.00039*ratioCoo),
        perCur=
          DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.4861255666760971,0.03002335398147802,-0.00021279533247713046,
            -0.0013756130911607226,-2.066990592237827e-05,-0.00019936826894468405},
          capFunFF={0.7685598823721829,0.31498953054702844},
          capFunFFCon={0.9856340780885993,0.016423336027544522},
          EIRFunT={0.6438101732437533,-0.02368485320203061,0.00047406260347688926,
            0.016757849333067214,0.00031069058049663586,-0.0004540361091002112},
          EIRFunFF={1.0451935090087352,-0.0614958411872731},
          EIRFunFFCon={1.1154782811513448,-0.13223908369989287},
          TConInMin=273.15 + 7.2,
          TConInMax=273.15 + 48.8,
          TEvaInMin=273.15 + 10,
          TEvaInMax=273.15 + 25.56,
          ffMin=0.875,
          ffMax=1.125,
          ffConMin=0.875,
          ffConMax=1.125))})          annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Constant constSpe(k=speRat)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Constant xLoa(k=xLoa_flow_in)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(souAir.ports[1], heaPum.port_a) annotation (Line(points={{-28,38},{-16,
          38},{-16,0},{-10,0}}, color={0,127,255}));
  connect(sinAir.ports[1], heaPum.port_b) annotation (Line(points={{32,40},{16,40},
          {16,0},{10,0}}, color={0,127,255}));
  connect(sinWat.ports[1], heaPum.portCon_b)
    annotation (Line(points={{-20,-50},{-6,-50},{-6,-10}}, color={0,127,255}));
  connect(souWat.ports[1], heaPum.portCon_a)
    annotation (Line(points={{20,-50},{6,-50},{6,-10}}, color={0,127,255}));
  connect(operMode.y, heaPum.uMod)
    annotation (Line(points={{-59,-30},{0,-30},{0,-11}}, color={255,127,0}));
  connect(constSpe.y, heaPum.speRat) annotation (Line(points={{-59,10},{-18,10},
          {-18,8},{-11.2,8}}, color={0,0,127}));
  connect(xLoa.y, souAir.Xi_in[1]) annotation (Line(points={{-59,50},{-54,50},{-54,
          34},{-50,34}}, color={0,0,127}));
  annotation (             __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/Cooling/WaterSource/Examples/VariableSpeed.mos"
        "Simulate and plot"),
    experiment(
      StopTime=10800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
            Documentation(info="<html>
<p>
This is a test model for
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.WaterSource.VariableSpeed\">
Buildings.Fluid.DXSystems.Cooling.WaterSource.VariableSpeed</a>.
The model has open-loop control and time-varying input conditions.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end VariableSpeedTest;
