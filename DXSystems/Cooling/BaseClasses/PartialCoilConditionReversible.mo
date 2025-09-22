within DXSystems.Cooling.BaseClasses;
partial block PartialCoilConditionReversible
  "Partial block for dry and wet coil conditions"
  extends DXSystems.Cooling.BaseClasses.PartialCoilInterface;

  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";

  replaceable DXSystems.BaseClasses.CapacityAirSource coiCap constrainedby
    DXSystems.Cooling.BaseClasses.PartialCapacity(sta=datCoi.sta, nSta=datCoi.nSta)
    "Performance data"
    annotation (Placement(transformation(extent={{-14,40},{6,60}})));

  Modelica.Blocks.Interfaces.IntegerInput uMod
   "Control input signal, cooling mode=-1, off=0, heating mode=+1"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-110}),
          iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));
protected
  DXSystems.Cooling.BaseClasses.SpeedShiftReversible speShiEIR(
    final variableSpeedCoil=variableSpeedCoil,
    final nSta=nSta,
    final speSet=datCoi.sta.spe,
    funSpeCoo=EIRFunSpeCoo,
    funSpeHea=EIRFunSpeHea) "Interpolates EIR"
    annotation (Placement(transformation(extent={{32,64},{46,78}})));
  DXSystems.Cooling.BaseClasses.SpeedShiftReversible speShiQ_flow(
    final variableSpeedCoil=variableSpeedCoil,
    final nSta=nSta,
    final speSet=datCoi.sta.spe,
    funSpeCoo=capFunSpeCoo,
    funSpeHea=capFunSpeHea) "Interpolates Q_flow"
    annotation (Placement(transformation(extent={{52,44},{66,58}})));

/*
// degree 1, without intercept (provided by @Mingzhe)
  parameter Real capFunSpeCoo[:] = {0.,1.3944587,0.};
  parameter Real capFunSpeHea[:] = {0.,1.57795755,0.};
  parameter Real EIRFunSpeCoo[:] = {0.,2.46561489,0.};
  parameter Real EIRFunSpeHea[:] = {0.,1.48333579,0.};
*/

// degree 1, with intercept
//   parameter Real capFunSpeCoo[:] = {0.2371152,1.0247960,0};
//   parameter Real capFunSpeHea[:] = {0.0681911,1.2494880,0};
//   parameter Real EIRFunSpeCoo[:] = {0.5000407,0.6716040,0};
//   parameter Real EIRFunSpeHea[:] = {0.5861590,0.5549308,0};

// degree 2, without intercept
//   parameter Real capFunSpeCoo[:] = {0,1.6822877,-0.4340557};
//   parameter Real capFunSpeHea[:] = {0,1.4389748,-0.1254374};
//   parameter Real EIRFunSpeCoo[:] = {0,2.0488651,-0.9039741};
//   parameter Real EIRFunSpeHea[:] = {0,2.1641055,-1.0541864};

// degree 2, without intercept (provided by @Mingzhe)
  parameter Real capFunSpeCoo[:] = {0,1.6822877,-0.4340557};
  parameter Real capFunSpeHea[:] = {0,1.4389748,-0.1254374};
//   parameter Real EIRFunSpeCoo[:] = {0,3.27841605,-1.6190544};
  parameter Real EIRFunSpeCoo[:] = {0,2.1856107395239834,-1.0793695578299136};
  parameter Real EIRFunSpeHea[:] = {0,2.1641055,-1.0541864};
equation
  connect(coiCap.EIR, speShiEIR.u)
                                  annotation (Line(
      points={{7,54},{10,54},{10,65.4},{30.6,65.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coiCap.Q_flow, speShiQ_flow.u)
                                        annotation (Line(
      points={{7,46},{12,46},{12,45.4},{50.6,45.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, speShiEIR.speRat)
                                   annotation (Line(
      points={{-110,76},{14,76},{14,71},{30.6,71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, speShiQ_flow.speRat)
                                      annotation (Line(
      points={{-110,76},{14,76},{14,51},{50.6,51}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(stage, speShiQ_flow.stage) annotation (Line(
      points={{-110,100},{20,100},{20,56.6},{50.6,56.6}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speShiEIR.stage, stage) annotation (Line(
      points={{30.6,76.6},{20,76.6},{20,100},{-110,100}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(coiCap.m_flow, m_flow) annotation (Line(
      points={{-15,50},{-92,50},{-92,24},{-110,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coiCap.TConIn, TConIn) annotation (Line(
      points={{-15,54.8},{-96,54.8},{-96,54},{-96,54},{-96,50},{-110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(coiCap.stage, stage) annotation (Line(
      points={{-15,60},{-60,60},{-60,100},{-110,100}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speShiQ_flow.y, Q_flow) annotation (Line(points={{66.7,51},{80,51},{
          80,40},{110,40}},
                         color={0,0,127}));
  connect(speShiEIR.y, EIR) annotation (Line(points={{46.7,71},{80,71},{80,80},
          {110,80}},color={0,0,127}));
  connect(uMod, speShiEIR.uMod) annotation (Line(points={{0,-110},{0,0},{39,0},
          {39,63.3}}, color={255,127,0}));
  connect(uMod, speShiQ_flow.uMod) annotation (Line(points={{0,-110},{0,0},{59,
          0},{59,43.3}}, color={255,127,0}));
  annotation ( Documentation(info="<html>
<p>
This partial block is the base class for
<a href=\"modelica://Buildings.Fluid.DXSystems.BaseClasses.DryCoil\">
Buildings.Fluid.DXSystems.BaseClasses.DryCoil</a> and
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.WetCoil\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.WetCoil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2023, by Xing Lu and Karthik Devaprasad:<br/>
Changed instance <code>cooCap</code> with class <code>CoolingCapacityAirCooled</code>
to instance <code>coiCap</code> with class
<a href=\"modelica://Buildings.Fluid.DXSystems.BaseClasses.CapacityAirSource\">
Buildings.Fluid.DXSystems.BaseClasses.CapacityAirSource</a>.
</li>
<li>
April 13, 2017, by Michael Wetter:<br/>
Removed connectors that are no longer needed.
</li>
<li>
February 17, 2017 by Yangyang Fu:<br/>
Added prefix <code>replaceable</code> to the type of <code>cooCap</code>.
</li>
<li>
August 1, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialCoilConditionReversible;
