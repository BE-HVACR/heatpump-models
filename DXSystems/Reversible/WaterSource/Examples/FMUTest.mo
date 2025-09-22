within DXSystems.Reversible.WaterSource.Examples;
model FMUTest
  extends Modelica.Icons.Example;
  VariableSpeedAdjustableCapacityFMU variableSpeedAdjustableCapacityFMU
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    duration=600,
    startTime=2400,
    height=-5,
    offset=273.15 + 23) "Temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.TimeTable speRat(table=[0.0,0.0; 100,0.0; 900,1; 1800,
        1; 2700,1; 3600,1])              "Speed ratio "
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.IntegerTable integerTable(table=[0,0; 100,0; 900,1;
        1800,1; 2700,-1; 3600,-1], extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-80,-42},{-60,-22}})));
  Modelica.Blocks.Sources.Ramp mCon_flow(
    duration=600,
    startTime=6000,
    height=0,
    offset=0.39) "Condenser inlet mass flow"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Modelica.Blocks.Sources.Constant TCon_flow(k=273.15 + 25)
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Modelica.Blocks.Sources.Constant XLoa_in(k=0.01)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Constant mLoa_flow(k=0.515)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(integerTable.y, variableSpeedAdjustableCapacityFMU.uMod) annotation (
      Line(points={{-59,-32},{-38,-32},{-38,-4},{-12,-4}}, color={255,127,0}));
  connect(mCon_flow.y, variableSpeedAdjustableCapacityFMU.mSou_flow_in)
    annotation (Line(points={{-59,-90},{-20,-90},{-20,-10},{-12,-10}}, color={0,
          0,127}));
  connect(TCon_flow.y, variableSpeedAdjustableCapacityFMU.TSou_in) annotation (
      Line(points={{-59,-60},{-22,-60},{-22,-7},{-12,-7}}, color={0,0,127}));
  connect(speRat.y, variableSpeedAdjustableCapacityFMU.speRat)
    annotation (Line(points={{-59,0},{-12,0}}, color={0,0,127}));
  connect(TEvaIn.y, variableSpeedAdjustableCapacityFMU.TLoa_in) annotation (
      Line(points={{-59,30},{-22,30},{-22,4},{-12,4}}, color={0,0,127}));
  connect(mLoa_flow.y, variableSpeedAdjustableCapacityFMU.mLoa_flow_in)
    annotation (Line(points={{-59,60},{-20,60},{-20,7},{-12,7}}, color={0,0,127}));
  connect(XLoa_in.y, variableSpeedAdjustableCapacityFMU.XLoa_in) annotation (
      Line(points={{-59,90},{-18,90},{-18,10},{-12,10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=7200, __Dymola_Algorithm="Dassl"));
end FMUTest;
