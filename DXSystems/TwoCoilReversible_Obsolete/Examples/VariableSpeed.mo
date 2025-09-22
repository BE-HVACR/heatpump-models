within DXSystems.TwoCoilReversible_Obsolete.Examples;
model VariableSpeed "Test model for variable speed DX coil"

  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
  extends Modelica.Icons.Example;

  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumAir,
    p(displayUnit="Pa"),
    nPorts=1)            "Sink on air side"
    annotation (Placement(transformation(extent={{52,30},{32,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T souAir(
    redeclare package Medium = MediumAir,
    use_T_in=true,
    m_flow=1.5,
    T=299.85,
    nPorts=1) "Source on air side"
    annotation (Placement(transformation(extent={{-48,28},{-28,48}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=600,
    startTime=2400,
    height=-5,
    offset=273.15 + 23) "Temperature"
    annotation (Placement(transformation(extent={{-90,32},{-70,52}})));

  Modelica.Blocks.Sources.Ramp mCon_flow(
    duration=600,
    startTime=6000,
    height=0,
    offset=1) "Condenser inlet mass flow"
    annotation (Placement(transformation(extent={{90,-48},{70,-28}})));
  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWater,
    use_T_in=false,
    use_m_flow_in=true,
    T=298.15,
    nPorts=1) "Source on water side"
    annotation (Placement(transformation(extent={{52,-56},{32,-36}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWater,
    p(displayUnit="Pa"),
    nPorts=1)            "Sink on water side"
    annotation (Placement(transformation(extent={{-44,-60},{-24,-40}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 100,0.0; 900,0.2;
        1800,0.8; 2700,0.75; 3600,0.75]) "Speed ratio "
    annotation (Placement(transformation(extent={{-90,2},{-70,22}})));
  DXSystems.TwoCoilReversible_Obsolete.VariableSpeedW2A w2AHP(
    redeclare package Medium1 = Buildings.Media.Air,
    redeclare package Medium2 = Buildings.Media.Water,
    m1_flow_nominal=1.5,
    m2_flow_nominal=1.5,
    QEva_flow_nominal=-21000,
    QCon_flow_nominal=21000)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Math.RealToInteger rti
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Pulse mode(
    amplitude=2,
    period=3600,
    offset=-1)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
equation
  connect(TEvaIn.y, souAir.T_in) annotation (Line(
      points={{-69,42},{-50,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mCon_flow.y, souWat.m_flow_in) annotation (Line(points={{69,-38},{54,
          -38},{54,-38}},          color={0,0,127}));
  connect(souAir.ports[1],w2AHP. port_a1) annotation (Line(points={{-28,38},{-14,
          38},{-14,6},{-8,6}}, color={0,127,255}));
  connect(w2AHP.port_b1, sinAir.ports[1]) annotation (Line(points={{12,6},{16,6},
          {16,40},{32,40}}, color={0,127,255}));
  connect(sinWat.ports[1],w2AHP. port_b2) annotation (Line(points={{-24,-50},{-14,
          -50},{-14,-6},{-8,-6}}, color={0,127,255}));
  connect(w2AHP.port_a2, souWat.ports[1]) annotation (Line(points={{12,-6},{22,-6},
          {22,-46},{32,-46}}, color={0,127,255}));
  connect(speRat.y,w2AHP. speRat) annotation (Line(points={{-69,12},{-12,12},{-12,
          14},{-9,14},{-9,9}}, color={0,0,127}));
  connect(rti.y, w2AHP.uMod) annotation (Line(points={{-39,-10},{-24,-10},{
          -24,0},{-9,0}}, color={255,127,0}));
  connect(mode.y, rti.u) annotation (Line(points={{-79,-30},{-68,-30},{-68,
          -10},{-62,-10}}, color={0,0,127}));
  annotation (             __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/Cooling/WaterSource/Examples/VariableSpeed.mos"
        "Simulate and plot"),
    experiment(
      StopTime=31536000,
      Interval=3600.00288,
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
end VariableSpeed;
