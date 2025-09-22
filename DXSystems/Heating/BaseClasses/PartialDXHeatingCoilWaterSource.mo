within DXSystems.Heating.BaseClasses;
partial model PartialDXHeatingCoilWaterSource
  "Partial model for DX cooling coil"
  extends DXSystems.Cooling.BaseClasses.PartialDXCoil(
    redeclare DXSystems.Heating.BaseClasses.DXHeatingWaterSource dxCoi(
        redeclare final package Medium = Medium, redeclare
        DXSystems.Cooling.AirSource.Data.Generic.DXCoil datCoi),
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
        prescribedHeatFlowRate=true),
    redeclare DXSystems.Cooling.AirSource.Data.Generic.DXCoil datCoi);

  Modelica.Blocks.Interfaces.RealOutput QLat_flow(
    final quantity="Power",
    final unit="W")
    "Latent heat flow rate"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
      iconTransformation(extent={{100,40},{120,60}})));

protected
  DXSystems.Cooling.BaseClasses.InputPower pwr
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

equation
  connect(dxCoi.SHR, pwr.SHR) annotation (Line(points={{1,52},{12,52},{12,64},{18,
          64}},    color={0,0,127}));
  connect(pwr.QLat_flow, QLat_flow) annotation (Line(points={{41,64},{80,64},{80,
          50},{110,50}}, color={0,0,127}));
  connect(T.y,dxCoi.TEvaIn)  annotation (Line(points={{-69,28},{-62,28},{-62,52},
          {-21,52}}, color={0,0,127}));
  connect(TOut,dxCoi.TConIn)  annotation (Line(points={{-110,30},{-92,30},{-92,
          57},{-21,57}}, color={0,0,127}));
  connect(pwr.P, P) annotation (Line(points={{41,76},{74,76},{74,90},{110,90}},
        color={0,0,127}));
  connect(pwr.QSen_flow, QSen_flow) annotation (Line(points={{41,70},{110,70}},
                            color={0,0,127}));
  connect(dxCoi.Q_flow, q.Q_flow) annotation (Line(points={{1,56},{22,56},{22,
          54},{42,54}}, color={0,0,127}));
  connect(dxCoi.EIR, pwr.EIR) annotation (Line(points={{1,60},{6,60},{6,76.6},{18,
          76.6}}, color={0,0,127}));
  connect(dxCoi.Q_flow, pwr.Q_flow) annotation (Line(points={{1,56},{10,56},{10,
          70},{18,70}}, color={0,0,127}));
  annotation (
defaultComponentName="dxCoi",
Documentation(info="<html>
<p>
This partial model is the base class for
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed\">
Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed</a>,
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.MultiStage\">
Buildings.Fluid.DXSystems.Cooling.AirSource.MultiStage</a> and
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed\">
Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={             Text(
          extent={{58,98},{102,78}},
          textColor={0,0,127},
          textString="P"),      Text(
          extent={{54,80},{98,60}},
          textColor={0,0,127},
          textString="QSen"),   Text(
          extent={{56,62},{100,42}},
          textColor={0,0,127},
          textString="QLat")}));
end PartialDXHeatingCoilWaterSource;
