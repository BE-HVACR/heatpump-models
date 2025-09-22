within DXSystems.Heating.BaseClasses;
model DXHeatingWaterSource "DX cooling coil operation"
  extends DXSystems.Cooling.BaseClasses.PartialCoilInterface;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching=true);

  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";

  DXSystems.BaseClasses.DryCoil dryCoi(
    redeclare final package Medium = Medium,
    final variableSpeedCoil=variableSpeedCoil,
    datCoi=datCoi,
    use_mCon_flow=use_mCon_flow) "Dry coil condition"
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Modelica.Blocks.Interfaces.RealOutput mWat_flow(quantity="MassFlowRate",
      unit="kg/s")
                 "Mass flow rate of water condensed at cooling coil"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealOutput SHR(min=0, max=1.0)
    "Sensible Heat Ratio: Ratio of sensible heat load to total heat load"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Sources.Constant one(k=1)
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Sources.Constant zer(k=0)
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
equation

  connect(TConIn, dryCoi.TConIn)  annotation (Line(
      points={{-110,50},{-76,50},{-76,-65},{-51,-65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, dryCoi.m_flow)  annotation (Line(
      points={{-110,24},{-72,24},{-72,-67.6},{-51,-67.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn, dryCoi.TEvaIn)  annotation (Line(
      points={{-110,5.55112e-16},{-68,5.55112e-16},{-68,-70},{-51,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, dryCoi.speRat)  annotation (Line(
      points={{-110,76},{-80,76},{-80,-62.4},{-51,-62.4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(stage, dryCoi.stage) annotation (Line(
      points={{-110,100},{-54,100},{-54,-60},{-51,-60}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mCon_flow, dryCoi.mCon_flow) annotation (Line(points={{-110,-100},{
          -84,-100},{-84,-80},{-51,-80}},
                                      color={0,0,127}));
  connect(dryCoi.EIR, EIR) annotation (Line(points={{-29,-62},{32,-62},{
          32,80},{110,80}}, color={0,0,127}));
  connect(dryCoi.Q_flow, Q_flow) annotation (Line(points={{-29,-66},{60,
          -66},{60,40},{110,40}}, color={0,0,127}));
  connect(one.y, SHR)
    annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
  connect(zer.y, mWat_flow)
    annotation (Line(points={{91,-80},{110,-80}}, color={0,0,127}));
  annotation (defaultComponentName="dxCoo", Documentation(info="<html>
<p>
This block combines the models for the dry coil and the wet coil.
Output of the block is the coil performance which, depending on the
mass fraction at the apparatus dew point temperature and
the mass fraction of the coil inlet air,
may be from the dry coil, the wet coil, or a weighted average of the two.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 20, 2012 by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
September 4, 2012 by Michael Wetter:<br/>
Renamed connector to follow naming convention.
</li>
<li>
April 12, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
         graphics={
        Text(
          extent={{-64,-56},{78,-92}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="DXHeat"),
        Line(
          points={{-78,26},{-46,26}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-44,26},{-48,28},{-48,24},{-44,26}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-78,4},{-46,4}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-44,4},{-48,6},{-48,2},{-44,4}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,32},{26,20}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{24,32},{-12,48}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{22,20},{-16,38}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{20,8},{-18,26}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{18,-4},{-20,14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{16,8},{22,-4}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{14,-32},{-24,-14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{16,-20},{-22,-2}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{12,-20},{18,-32}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{-78,-18},{-46,-18}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-42,-18},{-46,-16},{-46,-20},{-42,-18}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-76,46},{-44,46}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-42,46},{-46,48},{-46,44},{-42,46}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{74,32},{38,48}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{72,20},{34,38}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{70,32},{76,20}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{70,8},{32,26}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{68,-4},{30,14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{66,8},{72,-4}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{68,-22},{30,-4}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{66,-34},{28,-16}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{64,-22},{70,-34}},
          lineColor={0,0,255},
          lineThickness=0.5)}));
end DXHeatingWaterSource;
