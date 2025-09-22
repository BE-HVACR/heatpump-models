within DXSystems.Reversible.WaterSource.Examples;
model VariableSpeedFMU "Test model for variable speed DX coil"

  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = datCoiCoo.sta[datCoiCoo.nSta].nomVal.m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal=1000
    "Pressure drop at m_flow_nominal";
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal=20000
    "Pressure drop at mCon_flow_nominal";

  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumAir,
    p(displayUnit="Pa"),
    nPorts=1)            "Sink on air side"
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T souAir(
    redeclare package Medium = MediumAir,
    use_Xi_in=true,
    use_m_flow_in=true,
    use_T_in=true,
    T=299.85,
    nPorts=1) "Source on air side"
    annotation (Placement(transformation(extent={{-48,28},{-28,48}})));

  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWater,
    use_T_in=true,
    use_m_flow_in=true,
    T=298.15,
    nPorts=1) "Source on water side"
    annotation (Placement(transformation(extent={{48,-40},{28,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWater,
    p(displayUnit="Pa"),
    nPorts=1)            "Sink on water side"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  VariableSpeedReversible heaPum(
    datCoi=datCoiCoo,
    datCoiHea=datCoiHea,
    redeclare package MediumEva = MediumAir,
    redeclare package MediumCon = MediumWater,
    dpEva_nominal=dpEva_nominal,
    dpCon_nominal=dpCon_nominal,
    minSpeRat=datCoiCoo.minSpeRat)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  parameter Data.VSV024Hea2 datCoiHea annotation (Placement(transformation(extent={{20,60},
            {40,80}})));
  parameter Data.VSV024Coo2 datCoiCoo annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.IntegerInput uMod
    "Control input signal, cooling mode=-1, off=0, heating mode=+1"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput mLoa_flow_in "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput TLoa_in
    "Prescribed boundary temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput mSou_flow_in "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));
  Modelica.Blocks.Interfaces.RealInput TSou_in
    "Prescribed boundary temperature"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSouLvg(redeclare package Medium =
        MediumWater, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-30})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TLoaLvg(redeclare package Medium =
        MediumAir, m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,40})));
  Modelica.Blocks.Interfaces.RealInput XLoa_in
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
equation
  connect(souAir.ports[1], heaPum.port_a) annotation (Line(points={{-28,38},{-16,
          38},{-16,0},{-10,0}}, color={0,127,255}));
  connect(souWat.ports[1], heaPum.portCon_a)
    annotation (Line(points={{28,-30},{6,-30},{6,-10}}, color={0,127,255}));
  connect(heaPum.speRat, speRat) annotation (Line(points={{-11.2,8},{-66,8},{
          -66,0},{-120,0}}, color={0,0,127}));
  connect(heaPum.uMod, uMod)
    annotation (Line(points={{0,-11},{0,-40},{-120,-40}}, color={255,127,0}));
  connect(souAir.m_flow_in, mLoa_flow_in) annotation (Line(points={{-50,46},{
          -94,46},{-94,70},{-120,70}}, color={0,0,127}));
  connect(souAir.T_in, TLoa_in) annotation (Line(points={{-50,42},{-96,42},{-96,
          40},{-120,40}}, color={0,0,127}));
  connect(souWat.m_flow_in, mSou_flow_in) annotation (Line(points={{50,-22},{78,
          -22},{78,-100},{-120,-100}}, color={0,0,127}));
  connect(souWat.T_in, TSou_in) annotation (Line(points={{50,-26},{60,-26},{60,-70},
          {-120,-70}},                          color={0,0,127}));
  connect(sinWat.ports[1], TSouLvg.port_b)
    annotation (Line(points={{-60,-30},{-40,-30}}, color={0,127,255}));
  connect(TSouLvg.port_a, heaPum.portCon_b)
    annotation (Line(points={{-20,-30},{-6,-30},{-6,-10}}, color={0,127,255}));
  connect(sinAir.ports[1], TLoaLvg.port_b)
    annotation (Line(points={{60,40},{40,40}}, color={0,127,255}));
  connect(TLoaLvg.port_a, heaPum.port_b) annotation (Line(points={{20,40},{16,
          40},{16,0},{10,0}}, color={0,127,255}));
  connect(XLoa_in, souAir.Xi_in[1]) annotation (Line(points={{-120,100},{-76,
          100},{-76,34},{-50,34}}, color={0,0,127}));
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
end VariableSpeedFMU;
