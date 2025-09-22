within DXSystems.TwoCoilReversible_Obsolete;
model VariableSpeedW2A
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
//     m1_flow_nominal = QCon_flow_nominal/cp1_default/dTCon_nominal,
//     m2_flow_nominal = QEva_flow_nominal/cp2_default/dTEva_nominal
  parameter Modelica.Units.SI.HeatFlowRate QEva_flow_nominal(max=0)
    "Nominal cooling heat flow rate (QEva_flow_nominal < 0)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal(min=0)
    "Nominal heating flow rate" annotation (Dialog(group="Nominal condition"));

//   parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=datCoi.sta[datCoi.nSta].nomVal.m_flow_nominal
//     "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp1_nominal=1000
    "Pressure difference over load side";
  parameter Modelica.Units.SI.PressureDifference dp2_nominal=40000
    "Pressure difference over source side";

  Cooling.WaterSource.VariableSpeed coo(
    redeclare package MediumEva = Medium1,
    redeclare package MediumCon = Medium2,
    dpEva_nominal=dp1_nominal,
    dpCon_nominal=dp2_nominal,
    datCoi=datCoiCoo,
    show_T=true,
    minSpeRat=datCoiCoo.minSpeRat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Variable speed DX coil"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Heating.WaterSource.VariableSpeed hea(
    redeclare package MediumEva = Medium2,
    redeclare package MediumCon = Medium1,
    dpEva_nominal=dp2_nominal,
    dpCon_nominal=dp1_nominal,
    datCoi=datCoiHea,
    show_T=true,
    minSpeRat=datCoiHea.minSpeRat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Variable speed DX coil"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  parameter Heating.WaterSource.Data.Generic.DXCoil datCoiHea(nSta=1, sta={
        DXSystems.Heating.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          DXSystems.Heating.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=21000,
          COP_nominal=5,
          SHR_nominal=1,
          m_flow_nominal=1.5,
          mSou_flow_nominal=1,
          TEvaIn_nominal=273.15 + 26.67,
          TConIn_nominal=273.15 + 29.4),
        perCur=DXSystems.Heating.WaterSource.Examples.PerformanceCurves.Curve_I())})
                "Coil data"
    annotation (Placement(transformation(extent={{10,80},{30,100}})));
  Modelica.Blocks.Interfaces.IntegerInput uMod
    "Control input signal, cooling mode=1, off=0, heating mode=-1"
    annotation (Placement(transformation(extent={{-124,-14},{-100,10}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}}),
        iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Fluid.FixedResistances.Junction teeR2(
    redeclare package Medium = Medium2,
    m_flow_nominal={m2_flow_nominal,m2_flow_nominal,m2_flow_nominal},
    dp_nominal={0,0,0}) "Splitter" annotation (Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=180,
        origin={-40,-60})));
  Buildings.Fluid.FixedResistances.Junction teeR1(
    redeclare package Medium = Medium1,
    m_flow_nominal={m1_flow_nominal,m1_flow_nominal,m1_flow_nominal},
    dp_nominal={0,0,0}) "Splitter" annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=90,
        origin={60,20})));
  Modelica.Blocks.Interfaces.RealOutput P(quantity="Power", unit="W")
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput QSen_flow(quantity="Power", unit="W")
    "Sensible heat flow rate in evaporators"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput QLat_flow(quantity="Power", unit="W")
    "Latent heat flow rate in evaporators"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Logical.Switch switchCoo annotation (Placement(transformation(
          extent={{-30,-20},{-20,-10}}),
                                       iconTransformation(extent={{-120,-8},{-100,
            12}})));
  Modelica.Blocks.Sources.BooleanExpression if_cooling(y=uMod > 0) annotation (
      Placement(transformation(extent={{-70,-20},{-60,-10}}),
                                                            iconTransformation(
          extent={{-120,-8},{-100,12}})));
  Modelica.Blocks.Sources.Constant zer(k=0) annotation (Placement(
        transformation(extent={{-72,-4},{-62,6}}), iconTransformation(extent={{-120,
            -8},{-100,12}})));
  Modelica.Blocks.Logical.Switch switchHea annotation (Placement(transformation(
          extent={{-30,44},{-20,54}}),  iconTransformation(extent={{-120,-8},{-100,
            12}})));
  Modelica.Blocks.Sources.BooleanExpression if_heating(y=uMod < 0) annotation (
      Placement(transformation(extent={{-70,44},{-60,54}}),  iconTransformation(
          extent={{-120,-8},{-100,12}})));
  Modelica.Blocks.Math.MultiSum calPTot(nu=2) annotation (Placement(
        transformation(extent={{76.4,24.4},{87.6,35.6}})));
  Modelica.Blocks.Math.MultiSum calQSen(nu=2)
    annotation (Placement(transformation(extent={{74.4,-5.6},{85.6,5.6}})));
  Modelica.Blocks.Math.MultiSum calQLat(nu=2)
    annotation (Placement(transformation(extent={{74.4,-35.6},{85.6,-24.4}})));
  DHP.Fluid.ThreeWayValves.ThreeWay1in2out teeS1(
    redeclare package Medium = Medium1,
    m_flow_nominal_12=m1_flow_nominal,
    m_flow_nominal_13=m1_flow_nominal,
    dpValve_nominal=dp1_nominal) annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={-80,20})));
  DHP.Fluid.ThreeWayValves.ThreeWay1in2out teeS2(
    redeclare package Medium = Medium2,
    m_flow_nominal_12=m2_flow_nominal,
    m_flow_nominal_13=m2_flow_nominal,
    dpValve_nominal=dp2_nominal) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={40,-60})));
  parameter Cooling.WaterSource.Data.Generic.DXCoil datCoiCoo(nSta=1, sta={
        DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          DXSystems.Cooling.WaterSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-21000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=1.5,
          mCon_flow_nominal=1,
          TEvaIn_nominal=273.15 + 26.67,
          TConIn_nominal=273.15 + 29.4),
        perCur=DXSystems.Cooling.WaterSource.Examples.PerformanceCurves.Curve_I())})
    "Coil data"
    annotation (Placement(transformation(extent={{-30,80},{-10,100}})));

equation
  connect(teeR1.port_1, port_b1) annotation (Line(
      points={{60,24},{60,60},{100,60}},
      color={0,127,255},
      thickness=1));
  connect(if_cooling.y, switchCoo.u2)
    annotation (Line(points={{-59.5,-15},{-31,-15}},
                                                   color={255,0,255},
      pattern=LinePattern.Dash));
  connect(switchCoo.y, coo.speRat) annotation (Line(points={{-19.5,-15},{-16,
          -15},{-16,-32},{-11.2,-32}},
                                color={0,0,127},
      pattern=LinePattern.Dash));
  connect(if_heating.y, switchHea.u2)
    annotation (Line(points={{-59.5,49},{-31,49}},   color={255,0,255},
      pattern=LinePattern.Dash));
  connect(speRat, switchHea.u1) annotation (Line(points={{-110,90},{-50,90},{
          -50,53},{-31,53}},
                         color={0,0,127},
      pattern=LinePattern.Dash));
  connect(zer.y, switchHea.u3) annotation (Line(points={{-61.5,1},{-54,1},{-54,
          46},{-31,46},{-31,45}},         color={0,0,127}));
  connect(switchHea.y, hea.speRat) annotation (Line(points={{-19.5,49},{-11.2,
          49},{-11.2,28}},
                        color={0,0,127},
      pattern=LinePattern.Dash));
  connect(calPTot.y, P)
    annotation (Line(points={{88.552,30},{110,30}}, color={0,0,127}));
  connect(calQSen.y, QSen_flow)
    annotation (Line(points={{86.552,0},{110,0}}, color={0,0,127}));
  connect(calQLat.y, QLat_flow)
    annotation (Line(points={{86.552,-30},{110,-30}}, color={0,0,127}));
  connect(port_a1, teeS1.port_1) annotation (Line(
      points={{-100,60},{-80,60},{-80,26}},
      color={0,127,255},
      thickness=1));
  connect(uMod, teeS1.u) annotation (Line(points={{-112,-2},{-92,-2},{-92,20},{
          -87.2,20}}, color={255,127,0},
      pattern=LinePattern.Dash));
  connect(teeS1.port_3, hea.port_a) annotation (Line(
      points={{-74,20},{-10,20}},
      color={0,127,255},
      thickness=1));
  connect(hea.port_b, teeR1.port_3) annotation (Line(
      points={{10,20},{56,20}},
      color={0,127,255},
      thickness=1));
  connect(teeS1.port_2, coo.port_a) annotation (Line(
      points={{-80,14},{-80,-40},{-10,-40}},
      color={0,127,255},
      thickness=1));
  connect(coo.port_b, teeR1.port_2) annotation (Line(
      points={{10,-40},{60,-40},{60,16}},
      color={0,127,255},
      thickness=1));
  connect(port_a2, teeS2.port_1) annotation (Line(
      points={{100,-60},{46,-60}},
      color={0,127,255},
      thickness=1));
  connect(teeS2.port_2, coo.portCon_a) annotation (Line(
      points={{34,-60},{6,-60},{6,-50}},
      color={0,127,255},
      thickness=1));
  connect(teeS2.port_3, hea.portEva_a) annotation (Line(
      points={{40,-54},{40,0},{6,0},{6,10}},
      color={0,127,255},
      thickness=1));
  connect(uMod, teeS2.u) annotation (Line(points={{-112,-2},{-92,-2},{-92,-80},
          {40,-80},{40,-67.2}}, color={255,127,0},
      pattern=LinePattern.Dash));
  connect(port_b2, teeR2.port_1) annotation (Line(
      points={{-100,-60},{-44,-60}},
      color={0,127,255},
      thickness=1));
  connect(teeR2.port_2, coo.portCon_b) annotation (Line(
      points={{-36,-60},{-6,-60},{-6,-50}},
      color={0,127,255},
      thickness=1));
  connect(zer.y, switchCoo.u3) annotation (Line(points={{-61.5,1},{-54,1},{-54,
          -19},{-31,-19}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(speRat, switchCoo.u1) annotation (Line(points={{-110,90},{-50,90},{
          -50,-11},{-31,-11}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(hea.portEva_b, teeR2.port_3) annotation (Line(
      points={{-6,10},{-6,0},{-40,0},{-40,-56}},
      color={0,127,255},
      thickness=1));
  connect(hea.P, calPTot.u[1]) annotation (Line(points={{11,29},{43.7,29},{43.7,
          29.02},{76.4,29.02}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(coo.P, calPTot.u[2]) annotation (Line(points={{11,-31},{18,-31},{18,
          30.98},{76.4,30.98}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(hea.QSen_flow, calQSen.u[1]) annotation (Line(points={{11,26},{54,26},
          {54,-0.98},{74.4,-0.98}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(coo.QEvaSen_flow, calQSen.u[2]) annotation (Line(points={{11,-34},{22,
          -34},{22,0.98},{74.4,0.98}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(hea.QLat_flow, calQLat.u[1]) annotation (Line(points={{11,23},{28,23},
          {28,-30.98},{74.4,-30.98}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(coo.QEvaLat_flow, calQLat.u[2]) annotation (Line(points={{11,-37},{28,
          -37},{28,-29.02},{74.4,-29.02}}, color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,64},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-56},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{62,0},{100,0}},                 color={0,0,255}),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,64},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-56},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(extent={{66,28},{116,14}},   textString="P",
          textColor={0,0,127}),
        Line(points={{-100,90},{-80,90},{-80,14},{22,14}},
                                                    color={0,0,255}),
        Line(points={{62,0},{100,0}},                 color={0,0,255})}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>24/03/27 Yuhang</p>
<p>reversible variable speed water to air heat pump</p>
</html>"));
end VariableSpeedW2A;
