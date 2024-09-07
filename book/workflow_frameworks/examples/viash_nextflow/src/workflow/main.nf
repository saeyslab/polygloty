workflow wf {
  take:
  ch_in

  main:
  ch_out = ch_in

    | subset_obs.run(
      key: "subset_sm_name",
      fromState: ["input": "input"],
      args: [
        "obs_column": "sm_name",
        "obs_values": ["Belinostat", "Dimethyl Sulfoxide"]
      ],
      toState: ["data": "output"]
    )

    | subset_obs.run(
      key: "subset_cell_type",
      fromState: ["input": "data"],
      args: [
        "obs_column": "cell_type",
        "obs_values": ["T cells"]
      ],
      toState: ["data": "output"]
    )

    | subset_var.run(
      fromState: ["input": "data"],
      args: [
        "var_column": "highly_variable",
      ],
      toState: ["data": "output"]
    )

    | compute_pseudobulk.run(
      fromState: ["input": "data"],
      args: [
        "obs_column_index": "plate_well_celltype_reannotated",
        "obs_column_values": ["sm_name", "cell_type", "plate_name", "well"],
      ],
      toState: ["data": "output"]
    )

    | differential_expression.run(
      fromState: [
        "input": "data",
        "contrast": "contrast",
        "design_formula": "design_formula"
      ],
      toState: ["data": "output"]
    )

    | setState(["output": "data"])
    
  emit:
  ch_out
}