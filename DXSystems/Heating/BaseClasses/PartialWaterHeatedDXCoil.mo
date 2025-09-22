within DXSystems.Heating.BaseClasses;
model PartialWaterHeatedDXCoil "Base class for water source DX coils"
  extends Buildings.BaseClasses.BaseIcon;
  extends DXSystems.Cooling.BaseClasses.EssentialParameters(redeclare
      DXSystems.Heating.WaterSource.Data.Generic.DXCoil datCoi);

  replaceable package MediumCon =
      Modelica.Media.Interfaces.PartialMedium "Medium for condensor"
      annotation (choicesAllMatching = true);
  replaceable package MediumEva =
      Modelica.Media.Interfaces.PartialMedium "Medium for evaporator"
      annotation (choicesAllMatching = true);

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Boolean allowFlowReversalEva = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for evaporator"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalCon = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for condenser"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Pressure difference over evaporator at nominal flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Pressure difference over condenser at nominal flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean from_dpEva=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean from_dpCon=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Boolean linearizeFlowResistanceEva=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean linearizeFlowResistanceCon=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Real deltaMEva(final unit="1")=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Real deltaMCon(final unit="1")=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Modelica.Units.SI.Time tauEva=60
    "Time constant at nominal flow rate (used if energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.Units.SI.Time tauCon=60
    "Time constant at nominal flow rate (used if energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  parameter Boolean computeReevaporation=false
    "Set to true to compute reevaporation of water that accumulated on coil";

  // Initialization
  parameter MediumCon.AbsolutePressure pCon_start = MediumCon.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter MediumCon.Temperature TCon_start = MediumCon.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter MediumCon.MassFraction XCon_start[MediumCon.nX] = MediumCon.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=MediumCon.nXi > 0));
  parameter MediumCon.ExtraProperty CCon_start[MediumCon.nC](
    final quantity=MediumCon.extraPropertiesNames)=fill(0, MediumCon.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=MediumCon.nC > 0));
  parameter MediumCon.ExtraProperty CCon_nominal[MediumCon.nC](
    final quantity=MediumCon.extraPropertiesNames) = fill(1E-2, MediumCon.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 1", enable=MediumCon.nC > 0));

  parameter MediumEva.AbsolutePressure pEva_start = MediumEva.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter MediumEva.Temperature TEva_start = MediumEva.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter MediumEva.MassFraction XEva_start[MediumEva.nX] = MediumEva.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=MediumEva.nXi > 0));
  parameter MediumEva.ExtraProperty CEva_start[MediumEva.nC](
    final quantity=MediumEva.extraPropertiesNames)=fill(0, MediumEva.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=MediumEva.nC > 0));
  parameter MediumEva.ExtraProperty CEva_nominal[MediumEva.nC](
    final quantity=MediumEva.extraPropertiesNames) = fill(1E-2, MediumEva.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 2", enable=MediumEva.nC > 0));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));

  Modelica.Blocks.Interfaces.RealOutput P(quantity="Power", unit="W")
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput QSen_flow(quantity="Power", unit="W")
    "Sensible heat flow rate in evaporators"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput QLat_flow(quantity="Power", unit="W")
    "Latent heat flow rate in evaporators"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));

  // Ports
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = MediumCon,
    m_flow(min=if allowFlowReversalCon then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumCon.h_default))
    "Fluid connector for evaporator inlet (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = MediumCon,
    m_flow(max=if allowFlowReversalCon then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumCon.h_default))
    "Fluid connector b1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a portEva_a(
    redeclare final package Medium = MediumEva,
    m_flow(min=if allowFlowReversalEva then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumEva.h_default))
    "Fluid connector a of condenser (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{50,-110},{70,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_b portEva_b(
    redeclare final package Medium = MediumEva,
    m_flow(max=if allowFlowReversalEva then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumEva.h_default))
    "Fluid connector b of condenser (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-50,-110},{-70,-90}})));

  // Components
  replaceable DXSystems.Heating.BaseClasses.PartialDXHeatingCoilWaterSource con
    constrainedby PartialDXHeatingCoilWaterSource(
    redeclare final package Medium = MediumCon,
    redeclare final DXSystems.Heating.WaterSource.Data.Generic.DXCoil datCoi=
        datCoi,
    dxCoi(redeclare final DXSystems.Heating.WaterSource.Data.Generic.DXCoil
        datCoi=datCoi, dryCoi(redeclare final
          DXSystems.Heating.BaseClasses.CapacityWaterHeated coiCap, redeclare final
                DXSystems.Heating.WaterSource.Data.Generic.DXCoil datCoi=datCoi)),
    final use_mCon_flow=true,
    final dp_nominal=dpCon_nominal,
    final allowFlowReversal=allowFlowReversalCon,
    final show_T=false,
    final from_dp=from_dpCon,
    final linearizeFlowResistance=linearizeFlowResistanceCon,
    final deltaM=deltaMCon,
    final m_flow_small=mCon_flow_small,
    final tau=tauCon,
    final homotopyInitialization=homotopyInitialization,
    final energyDynamics=energyDynamics,
    final p_start=pCon_start,
    final T_start=TCon_start,
    final X_start=XCon_start,
    final C_start=CCon_start,
    final computeReevaporation=computeReevaporation) "Direct evaporative coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

//     watVapEva(nomVal=
//           DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
//                 Q_flow_nominal=datCoi.sta[nSta].nomVal.Q_flow_nominal,
//                 COP_nominal=datCoi.sta[nSta].nomVal.COP_nominal,
//                 SHR_nominal=datCoi.sta[nSta].nomVal.SHR_nominal,
//                 m_flow_nominal=datCoi.sta[nSta].nomVal.m_flow_nominal,
//                 TEvaIn_nominal=datCoi.sta[nSta].nomVal.TEvaIn_nominal,
//                 TConIn_nominal=datCoi.sta[nSta].nomVal.TConIn_nominal,
//                 phiIn_nominal=datCoi.sta[nSta].nomVal.phiIn_nominal,
//                 p_nominal=datCoi.sta[nSta].nomVal.p_nominal,
//                 tWet=datCoi.sta[nSta].nomVal.tWet,
//                 gamma=datCoi.sta[nSta].nomVal.gamma))

  Buildings.Fluid.HeatExchangers.HeaterCooler_u watHeaEva(
    redeclare package Medium=MediumEva,
    final m_flow_nominal=datCoi.sta[nSta].nomVal.mSou_flow_nominal,
    final Q_flow_nominal=datCoi.sta[nSta].nomVal.Q_flow_nominal*(1 - 1/datCoi.sta[
        nSta].nomVal.COP_nominal),
    final allowFlowReversal=allowFlowReversalEva,
    final show_T=false,
    final from_dp=from_dpEva,
    final linearizeFlowResistance=linearizeFlowResistanceEva,
    final dp_nominal=dpEva_nominal,
    final deltaM=deltaMEva,
    final m_flow_small=mEva_flow_small,
    final tau=tauEva,
    final homotopyInitialization=homotopyInitialization,
    final energyDynamics=energyDynamics,
    final p_start=pEva_start,
    final T_start=TEva_start,
    final X_start=XEva_start,
    final C_start=CEva_start) "Water source evaporator"
    annotation (Placement(transformation(extent={{-20,-90},{-40,-70}})));

  // Variables
  Modelica.Units.SI.Temperature TEvaEnt=MediumEva.temperature(
      MediumEva.setState_phX(portEva_a.p, inStream(portEva_a.h_outflow)))
    "Temperature of fluid entering the condenser";

  MediumCon.ThermodynamicState sta_a1=MediumCon.setState_phX(
      port_a.p,
      noEvent(actualStream(port_a.h_outflow)),
      noEvent(actualStream(port_a.Xi_outflow))) if show_T
    "Medium properties in port_a1";
  MediumCon.ThermodynamicState sta_b1=MediumCon.setState_phX(
      port_b.p,
      noEvent(actualStream(port_b.h_outflow)),
      noEvent(actualStream(port_b.Xi_outflow))) if show_T
    "Medium properties in port_b1";
  MediumEva.ThermodynamicState sta_a2=MediumEva.setState_phX(portEva_a.p,
      noEvent(actualStream(portEva_a.h_outflow)),
      noEvent(actualStream(portEva_a.Xi_outflow))) if show_T
    "Medium properties in port_a2";
  MediumEva.ThermodynamicState sta_b2=MediumEva.setState_phX(portEva_b.p,
      noEvent(actualStream(portEva_b.h_outflow)),
      noEvent(actualStream(portEva_b.Xi_outflow))) if show_T
    "Medium properties in port_b2";

protected
  final parameter MediumCon.MassFlowRate mCon_flow_small(min=0) = datCoi.m_flow_small
    "Small mass flow rate for regularization of zero flow at evaporator"
    annotation(Dialog(tab = "Advanced"));
  parameter MediumEva.MassFlowRate mEva_flow_small(min=0) = 1E-4*abs(datCoi.sta[nSta].nomVal.mSou_flow_nominal)
    "Small mass flow rate for regularization of zero flow at condenser"
    annotation(Dialog(tab = "Advanced"));

  Modelica.Blocks.Sources.RealExpression u(final y=(con.dxCoi.Q_flow - con.P)/
        watHeaEva.Q_flow_nominal)
    "Signal of total heat flow added by evaporator"  annotation (Placement(
        transformation(
        extent={{-13,-10},{13,10}},
        origin={-31,-60})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFloEva(redeclare final package
      Medium =         MediumEva) "Mass flow through condenser"
    annotation (Placement(transformation(extent={{40,-90},{20,-70}})));

  Modelica.Blocks.Sources.RealExpression TEvaEntWat(final y=TEvaEnt)
    "Temperature of water entering condenser" annotation (Placement(
        transformation(
        extent={{-10,-9},{10,9}},
        origin={-50,11})));

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(u.y,watHeaEva. u) annotation (Line(points={{-16.7,-60},{-8,-60},{-8,
          -74},{-18,-74}},
                    color={0,0,127}));
  connect(con.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}},           color={0,127,255}));
  connect(con.port_a, port_a)
    annotation (Line(points={{-10,0},{-100,0}},            color={0,127,255}));
  connect(watHeaEva.port_b,portEva_b)  annotation (Line(points={{-40,-80},{-60,-80},
          {-60,-100}}, color={0,127,255}));
  connect(con.P, P) annotation (Line(points={{11,9},{40,9},{40,90},{110,90}},
        color={0,0,127}));
  connect(con.QSen_flow, QSen_flow) annotation (Line(points={{11,7},{44,7},{44,60},
          {110,60}}, color={0,0,127}));
  connect(con.QLat_flow, QLat_flow) annotation (Line(points={{11,5},{48,5},{48,30},
          {110,30}}, color={0,0,127}));
  connect(watHeaEva.port_a,senMasFloEva. port_b)
    annotation (Line(points={{-20,-80},{20,-80}},color={0,127,255}));
  connect(senMasFloEva.m_flow,con. mCon_flow) annotation (Line(points={{30,-69},
          {30,-30},{-20,-30},{-20,-3},{-11,-3}},                       color={0,
          0,127}));
  connect(TEvaEntWat.y,con. TOut) annotation (Line(points={{-39,11},{-20,11},{-20,
          3},{-11,3}},                     color={0,0,127}));
  connect(portEva_a,senMasFloEva. port_a) annotation (Line(points={{60,-100},{60,
          -100},{60,-80},{40,-80}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{54,100},{98,80}},
          textColor={0,0,127},
          textString="P"),
        Rectangle(
          extent={{-72,-52},{72,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,50},{32,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-72,68},{72,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,50},{-34,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-36,0},{-46,10},{-26,10},{-36,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-36,0},{-46,-12},{-26,-12},{-36,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-38,-12},{-34,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{8,22},{52,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{30,22},{12,-10},{48,-10},{30,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-96,-4},{-58,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26.25,-5},{-26.25,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          origin={-63,-25.75},
          rotation=90),
        Rectangle(
          extent={{-28,-4},{28,4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={62,-24},
          rotation=90),
        Rectangle(
          extent={{58,-4},{94,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{75,-2},{-75,2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          origin={-84,-13},
          rotation=90),
        Rectangle(
          extent={{3,-2},{-3,2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          origin={-60,-87},
          rotation=90),
        Rectangle(
          extent={{2,-13},{-2,13}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          origin={-71,-86},
          rotation=90),
        Rectangle(
          extent={{2,-7},{-2,7}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,85,85},
          fillPattern=FillPattern.Solid,
          origin={-79,60},
          rotation=90),
        Rectangle(
          extent={{2,-13},{-2,13}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={140,142,255},
          fillPattern=FillPattern.Solid,
          origin={73,-86},
          rotation=90),
        Rectangle(
          extent={{3,-2},{-3,2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={140,142,255},
          fillPattern=FillPattern.Solid,
          origin={60,-87},
          rotation=90),
        Rectangle(
          extent={{75,-2},{-75,2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={140,142,255},
          fillPattern=FillPattern.Solid,
          origin={84,-13},
          rotation=90),
        Rectangle(
          extent={{2,-7},{-2,7}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={140,142,255},
          fillPattern=FillPattern.Solid,
          origin={79,60},
          rotation=90),         Text(
          extent={{52,42},{96,22}},
          textColor={0,0,127},
          textString="QConLat"),Text(
          extent={{54,72},{98,52}},
          textColor={0,0,127},
          textString="QConSen")}),             Documentation(info="<html>
<p>
This model can be used to simulate a water source DX cooling coil with single speed compressor.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.UsersGuide\">
Buildings.Fluid.DXSystems.Cooling.UsersGuide</a>
for an explanation of the model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 5 , 2023, by Xing Lu:<br/>
Changed instance name <code>dxCoo</code> in instance <code>eva</code> to
<code>dxCoi</code>. Changed baseclass used from <code>PartialDXCoil</code> to
<code>PartialDXCoolingCoil</code>.<br/>
Connect statements with references to <code>TConIn</code> changed to <code>TOut</code>.
</li>
<li>
March 3, 2022, by Michael Wetter:<br/>
Moved <code>massDynamics</code> to <code>Advanced</code> tab and
added assertion for correct combination of energy and mass dynamics.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">issue 1542</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
March 21, 2017, by Michael Wetter:<br/>
Moved assignment of evaporator data <code>datCoi</code> from the
<code>constrainedBy</code> declaration in the base class
to the instantiation to work around a limitation of JModelica.
</li>
<li>
March 7, 2017, by Michael Wetter:<br/>
Refactored implementation to avoid code duplication and to propagate parameters.
</li>
<li>
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialWaterHeatedDXCoil;
