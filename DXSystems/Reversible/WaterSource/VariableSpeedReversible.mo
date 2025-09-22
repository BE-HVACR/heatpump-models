within DXSystems.Reversible.WaterSource;
model VariableSpeedReversible "Variable speed water source DX coils"
  extends DXSystems.Cooling.BaseClasses.PartialWaterCooledDXCoilReversible(
      redeclare final VariableSpeedAirReversible loa(final minSpeRat=minSpeRat,
        final speRatDeaBan=speRatDeaBan));

  parameter Real minSpeRat(min=0,max=1) "Minimum speed ratio";
  parameter Real speRatDeaBan= 0.05 "Deadband for minimum speed ratio";

  Real COP(unit="1")
                    "Coefficient of performance";
  Modelica.Blocks.Interfaces.RealInput speRat(
   min=0,
   max=1,
   final unit="1") "Speed ratio"
    annotation (Placement(transformation(extent={{-124,68},{-100,92}})));

  Modelica.Blocks.Interfaces.IntegerInput uMod
    "Control input signal, cooling mode=-1, off=0, heating mode=+1"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-40}),
          iconTransformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-110})));

equation
  if P > 1E-4*abs(datCoi.sta[nSta].nomVal.Q_flow_nominal/datCoi.sta[nSta].nomVal.COP_nominal) then
    COP =abs(QSen_flow + QLat_flow)/P;
  else COP =0;
  end if;

  connect(speRat,loa.speRat)  annotation (Line(points={{-112,80},{-16,80},{-16,
          8},{-11,8}},
                     color={0,0,127}));
  connect(uMod,loa.uMod)  annotation (Line(points={{-110,-40},{0,-40},{0,-11}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                           Line(points={{-122,80},{-90,80},{-90,23.8672},{-4,24},
              {-4,2.0215},{8,2}},                                     color={0,0,
              127})}),
    Documentation(info="<html>
<p>
This model can be used to simulate a water source DX cooling coil with variable speed compressor.
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
April 5, 2023, by Xing Lu:<br/>
Updated air-source cooling coil class being extended from <code>VariableSpeed</code>
to <a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed\">
Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed</a>.
</li>
<li>
March 7, 2022, by Michael Wetter:<br/>
Set <code>final massDynamics=energyDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
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
end VariableSpeedReversible;
