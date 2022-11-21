[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Problem]
  type = ReferenceResidualProblem
  reference_vector = 'ref'
  extra_tag_vectors = 'ref'
  group_variables = 'disp_x disp_y disp_z'
[]

[Mesh]
  file = A1-unreinforced.e
[]

[Variables]
  [T]
    initial_condition = 10.6
  []
  [rh]
    initial_condition = 0.8
  []
[]

[AuxVariables]
  [resid_x]
  []
  [resid_y]
  []
  [resid_z]
  []
  [ASR_ex]
    order = CONSTANT
    family = MONOMIAL
  []
  [ASR_vstrain]
    order = CONSTANT
    family = MONOMIAL
  []
  [ASR_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [ASR_strain_yy]
    order = CONSTANT
    family = MONOMIAL
  []
  [ASR_strain_zz]
    order = CONSTANT
    family = MONOMIAL
  []
  [ASR_strain_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [ASR_strain_yz]
    order = CONSTANT
    family = MONOMIAL
  []
  [ASR_strain_zx]
    order = CONSTANT
    family = MONOMIAL
  []
  [volumetric_strain]
    order = CONSTANT
    family = MONOMIAL
  []
  [thermal_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [thermal_strain_yy]
    order = CONSTANT
    family = MONOMIAL
  []
  [thermal_strain_zz]
    order = CONSTANT
    family = MONOMIAL
  []
  [thermal_conductivity]
    order = CONSTANT
    family = Monomial
  []
  [thermal_capacity]
    order = CONSTANT
    family = Monomial
  []
  [humidity_diffusivity]
    order = CONSTANT
    family = Monomial
  []
  [damage_index]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Modules/TensorMechanics/Master]
  [concrete]
    strain = FINITE
    add_variables = true
    eigenstrain_names = 'asr_expansion thermal_expansion'
    generate_output = 'stress_xx stress_yy stress_zz stress_xy stress_yz stress_zx vonmises_stress '
                      'hydrostatic_stress elastic_strain_xx elastic_strain_yy elastic_strain_zz '
                      'strain_xx strain_yy strain_zz'
    extra_vector_tags = 'ref'
    temperature = T
  []
[]

[Kernels]
  [T_td]
    type = ConcreteThermalTimeIntegration
    variable = T
    extra_vector_tags = 'ref'
  []
  [T_diff]
    type = ConcreteThermalConduction
    variable = T
    extra_vector_tags = 'ref'
  []
  [T_conv]
    type = ConcreteThermalConvection
    variable = T
    relative_humidity = rh
    extra_vector_tags = 'ref'
  []
  [T_adsorption]
    type = ConcreteLatentHeat
    variable = T
    H = rh
    extra_vector_tags = 'ref'
  []
  [rh_td]
    type = ConcreteMoistureTimeIntegration
    variable = rh
    extra_vector_tags = 'ref'
  []
  [rh_diff]
    type = ConcreteMoistureDiffusion
    variable = rh
    temperature = T
    extra_vector_tags = 'ref'
  []
[]

[AuxKernels]
  [ASR_ex]
    type = MaterialRealAux
    variable = ASR_ex
    property = ASR_extent
    execute_on = 'timestep_end'
  []
  [ASR_vstrain]
    type = MaterialRealAux
    variable = ASR_vstrain
    property = ASR_volumetric_strain
    execute_on = 'timestep_end'
  []
  [ASR_strain_xx]
    type = RankTwoAux
    rank_two_tensor = asr_expansion
    variable = ASR_strain_xx
    index_i = 0
    index_j = 0
    execute_on = 'timestep_end'
  []
  [ASR_strain_yy]
    type = RankTwoAux
    rank_two_tensor = asr_expansion
    variable = ASR_strain_yy
    index_i = 1
    index_j = 1
    execute_on = 'timestep_end'
  []
  [ASR_strain_zz]
    type = RankTwoAux
    rank_two_tensor = asr_expansion
    variable = ASR_strain_zz
    index_i = 2
    index_j = 2
    execute_on = 'timestep_end'
  []
  [ASR_strain_xy]
    type = RankTwoAux
    rank_two_tensor = asr_expansion
    variable = ASR_strain_xy
    index_i = 0
    index_j = 1
    execute_on = 'timestep_end'
  []
  [ASR_strain_yz]
    type = RankTwoAux
    rank_two_tensor = asr_expansion
    variable = ASR_strain_yz
    index_i = 1
    index_j = 2
    execute_on = 'timestep_end'
  []
  [ASR_strain_zx]
    type = RankTwoAux
    rank_two_tensor = asr_expansion
    variable = ASR_strain_zx
    index_i = 0
    index_j = 2
    execute_on = 'timestep_end'
  []
  [thermal_strain_xx]
    type = RankTwoAux
    rank_two_tensor = thermal_expansion
    variable = thermal_strain_xx
    index_i = 0
    index_j = 0
    execute_on = 'timestep_end'
  []
  [thermal_strain_yy]
    type = RankTwoAux
    rank_two_tensor = thermal_expansion
    variable = thermal_strain_yy
    index_i = 1
    index_j = 1
    execute_on = 'timestep_end'
  []
  [thermal_strain_zz]
    type = RankTwoAux
    rank_two_tensor = thermal_expansion
    variable = thermal_strain_zz
    index_i = 2
    index_j = 2
    execute_on = 'timestep_end'
  []
  [volumetric_strain]
    type = RankTwoScalarAux
    scalar_type = VolumetricStrain
    rank_two_tensor = total_strain
    variable = volumetric_strain
  []
  [k]
    type = MaterialRealAux
    variable = thermal_conductivity
    property = thermal_conductivity
    execute_on = 'timestep_end'
  []
  [capacity]
    type = MaterialRealAux
    variable = thermal_capacity
    property = thermal_capacity
    execute_on = 'timestep_end'
  []
  [rh_duff]
    type = MaterialRealAux
    variable = humidity_diffusivity
    property = humidity_diffusivity
    execute_on = 'timestep_end'
  []
  [damage_index]
    type = MaterialRealAux
    variable = damage_index
    property = damage_index
    execute_on = timestep_end
  []
[]

[Functions]
  [ramp_temp]
    type = PiecewiseLinear
    data_file = temperature_history.csv
    format = columns
  []

  [ramp_humidity]
    type = PiecewiseLinear
    data_file = humidity_history.csv
    format = columns
  []
[]

[Materials]
  [concrete]
    type = ConcreteThermalMoisture
    # setup thermal property models and parameters
    # options available: CONSTANT ASCE-1992 KODUR-2004 EUROCODE-2004 KIM-2003
    thermal_model = KODUR-2004
    aggregate_type = Siliceous #options: Siliceous Carbonate

    ref_density = 2231.0 # in kg/m^3
    ref_specific_heat = 1100.0 # in J/(Kg.0C)
    ref_thermal_conductivity = 3 # in W/(m.0C)

    # setup moisture capacity and humidity diffusivity models
    aggregate_pore_type = dense #options: dense porous
    aggregate_mass = 1877.0 #mass of aggregate (kg) per m^3 of concrete
    aggregate_vol_fraction = 0.7
    cement_type = 1 #options: 1 2 3 4
    cement_mass = 354.0 #mass of cement (kg) per m^3 of concrete
    water_to_cement_ratio = 0.5
    concrete_cure_time = 28.0 #curing time in (days)

    # options available for humidity diffusivity:
    moisture_model = Xi #options: Bazant Mensi
    D1 = 3.0e-8

    coupled_moisture_diffusivity_factor = 1.0e-2 # factor for mositure diffusivity due to heat

    # coupled nonlinear variables
    relative_humidity = rh
    temperature = T
  []

  [creep]
    type = LinearViscoelasticStressUpdate
    # block = 1
  []
  [logcreep]
    type = ConcreteLogarithmicCreepModel
    poissons_ratio = 0.22
    youngs_modulus = 37.3e9
    recoverable_youngs_modulus = 37.3e9
    recoverable_viscosity = 1
    long_term_viscosity = 1
    long_term_characteristic_time = 1
    humidity = rh
    temperature = T
    activation_temperature = 23.0
  []

  [ASR_expansion]
    type = ConcreteASREigenstrain
    expansion_type = Anisotropic

    reference_temperature = 35.0
    temperature_unit = Celsius
    max_volumetric_expansion = 2.5e-2

    characteristic_time = 18.9
    latency_time = 18.0
    characteristic_activation_energy = 5400.0
    latency_activation_energy = 9400.0
    stress_latency_factor = 1.0

    compressive_strength = 31.0e6
    compressive_stress_exponent = 0.0
    expansion_stress_limit = 8.0e6

    tensile_strength = 3.2e6
    tensile_retention_factor = 1.0
    tensile_absorption_factor = 1.0

    ASR_dependent_tensile_strength = false
    residual_tensile_strength_fraction = 1.0

    temperature = T
    relative_humidity = rh
    rh_exponent = 1.0
    eigenstrain_name = asr_expansion
    absolute_tolerance = 1e-10
    output_iteration_info_on_error = true
  []

  [thermal_strain_concrete]
    type = ComputeThermalExpansionEigenstrain
    temperature = T
    thermal_expansion_coeff = 8.0e-6
    stress_free_temperature = 10.6
    eigenstrain_name = thermal_expansion
  []

  [ASR_damage_concrete]
    type = ConcreteASRMicrocrackingDamage
    residual_youngs_modulus_fraction = 0.1
  []
  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'creep'
    damage_model = ASR_damage_concrete
  []
[]

[UserObjects]
  [visco_update]
    type = LinearViscoelasticityManager
    viscoelastic_model = logcreep
  []
[]

[BCs]
  [left]
    type = DirichletBC
    variable = disp_x
    boundary = '2000 2005'
    value = 0.0
  []
  [bottom]
    type = DirichletBC
    variable = disp_y
    boundary = '2000 2001'
    value = 0.0
  []
  [back]
    type = DirichletBC
    variable = disp_z
    boundary = '2000 2005'
    value = 0.0
  []
  [T]
    type = FunctionDirichletBC
    variable = T
    boundary = '101 102 103 104 105 106'
    function = ramp_temp
  []
  [rh]
    type = FunctionDirichletBC
    variable = rh
    boundary = '101 102 103 104 105 106'
    function = ramp_humidity
  []
[]

[Postprocessors]
  [nelem]
    type = NumElems
  []
  [ndof]
    type = NumDOFs
  []
  [ASR_strain]
    type = ElementAverageValue
    variable = ASR_vstrain
  []
  [ASR_strain_xx]
    type = ElementAverageValue
    variable = ASR_strain_xx
  []
  [ASR_strain_yy]
    type = ElementAverageValue
    variable = ASR_strain_yy
  []
  [ASR_strain_zz]
    type = ElementAverageValue
    variable = ASR_strain_zz
  []
  [ASR_ext]
    type = ElementAverageValue
    variable = ASR_ex
  []
  [vonmises]
    type = ElementAverageValue
    variable = vonmises_stress
  []
  [vstrain]
    type = ElementAverageValue
    variable = volumetric_strain
  []
  [strain_xx]
    type = ElementAverageValue
    variable = strain_xx
  []
  [strain_yy]
    type = ElementAverageValue
    variable = strain_yy
  []
  [strain_zz]
    type = ElementAverageValue
    variable = strain_zz
  []

  [temp]
    type = ElementAverageValue
    variable = T
  []
  [temp_bc]
    type = SideAverageValue
    variable = T
    boundary = 102
  []
  [humidity]
    type = ElementAverageValue
    variable = rh
  []
  [humidity_bc]
    type = SideAverageValue
    variable = rh
    boundary = 102
  []
  [thermal_strain_xx]
    type = ElementAverageValue
    variable = thermal_strain_xx
  []
  [thermal_strain_yy]
    type = ElementAverageValue
    variable = thermal_strain_yy
  []
  [thermal_strain_zz]
    type = ElementAverageValue
    variable = thermal_strain_zz
  []
  [disp_x_101]
    type = SideAverageValue
    variable = disp_x
    boundary = 101
  []
  [disp_x_102]
    type = SideAverageValue
    variable = disp_x
    boundary = 102
  []
  [disp_x_103]
    type = SideAverageValue
    variable = disp_x
    boundary = 103
  []
  [disp_x_104]
    type = SideAverageValue
    variable = disp_x
    boundary = 104
  []
  [disp_x_105]
    type = SideAverageValue
    variable = disp_x
    boundary = 105
  []
  [disp_x_106]
    type = SideAverageValue
    variable = disp_x
    boundary = 106
  []
  [disp_y_101]
    type = SideAverageValue
    variable = disp_y
    boundary = 101
  []
  [disp_y_102]
    type = SideAverageValue
    variable = disp_y
    boundary = 102
  []
  [disp_y_103]
    type = SideAverageValue
    variable = disp_y
    boundary = 103
  []
  [disp_y_104]
    type = SideAverageValue
    variable = disp_y
    boundary = 104
  []
  [disp_y_105]
    type = SideAverageValue
    variable = disp_y
    boundary = 105
  []
  [disp_y_106]
    type = SideAverageValue
    variable = disp_y
    boundary = 106
  []
  [disp_z_101]
    type = SideAverageValue
    variable = disp_z
    boundary = 101
  []
  [disp_z_102]
    type = SideAverageValue
    variable = disp_z
    boundary = 102
  []
  [disp_z_103]
    type = SideAverageValue
    variable = disp_z
    boundary = 103
  []
  [disp_z_104]
    type = SideAverageValue
    variable = disp_z
    boundary = 104
  []
  [disp_z_105]
    type = SideAverageValue
    variable = disp_z
    boundary = 105
  []
  [disp_z_106]
    type = SideAverageValue
    variable = disp_z
    boundary = 106
  []
  [disp_x_p1_pos]
    type = PointValue
    variable = disp_x
    point = '0.24 -0.08 -0.08'
  []
  [disp_x_p1_neg]
    type = PointValue
    variable = disp_x
    point = '-0.24 -0.08 -0.08'
  []
  [disp_x_p2_pos]
    type = PointValue
    variable = disp_x
    point = '0.24 -0.08 0.08'
  []
  [disp_x_p2_neg]
    type = PointValue
    variable = disp_x
    point = '-0.24 -0.08 0.08'
  []
  [disp_x_p3_pos]
    type = PointValue
    variable = disp_x
    point = '0.24 0.08 -0.08'
  []
  [disp_x_p3_neg]
    type = PointValue
    variable = disp_x
    point = '-0.24 0.08 -0.08'
  []
  [disp_x_p4_pos]
    type = PointValue
    variable = disp_x
    point = '0.24 0.08 0.08'
  []
  [disp_x_p4_neg]
    type = PointValue
    variable = disp_x
    point = '-0.24 0.08 0.08'
  []
  [disp_x_p5_pos]
    type = PointValue
    variable = disp_x
    point = '0.24 0.08 -0.235'
  []
  [disp_x_p5_neg]
    type = PointValue
    variable = disp_x
    point = '-0.24 0.08 -0.235'
  []
  [disp_x_p6_pos]
    type = PointValue
    variable = disp_x
    point = '0.24 0.08 0.235'
  []
  [disp_x_p6_neg]
    type = PointValue
    variable = disp_x
    point = '-0.24 0.08 0.235'
  []

  [disp_y_p1_pos]
    type = PointValue
    variable = disp_y
    point = '-0.08 0.24 -0.08'
  []
  [disp_y_p1_neg]
    type = PointValue
    variable = disp_y
    point = '-0.08 -0.24 -0.08'
  []
  [disp_y_p2_pos]
    type = PointValue
    variable = disp_y
    point = '-0.08 0.24 0.08'
  []
  [disp_y_p2_neg]
    type = PointValue
    variable = disp_y
    point = '-0.08 -0.24 0.08'
  []
  [disp_y_p3_pos]
    type = PointValue
    variable = disp_y
    point = '0.08 0.24 -0.08'
  []
  [disp_y_p3_neg]
    type = PointValue
    variable = disp_y
    point = '0.08 -0.24 -0.08'
  []
  [disp_y_p4_pos]
    type = PointValue
    variable = disp_y
    point = '0.08 0.24 0.08'
  []
  [disp_y_p4_neg]
    type = PointValue
    variable = disp_y
    point = '0.08 -0.24 0.08'
  []
  [disp_y_p5_pos]
    type = PointValue
    variable = disp_y
    point = '0.08 0.24 -0.235'
  []
  [disp_y_p5_neg]
    type = PointValue
    variable = disp_y
    point = '0.08 -0.24 -0.235'
  []
  [disp_y_p6_pos]
    type = PointValue
    variable = disp_y
    point = '0.08 0.24 0.235'
  []
  [disp_y_p6_neg]
    type = PointValue
    variable = disp_y
    point = '0.08 -0.24 0.235'
  []
  [disp_y_p7_pos]
    type = PointValue
    variable = disp_y
    point = '-0.235 0.24 0.08'
  []
  [disp_y_p7_neg]
    type = PointValue
    variable = disp_y
    point = '-0.235 -0.24 0.08'
  []
  [disp_y_p8_pos]
    type = PointValue
    variable = disp_y
    point = '0.235 0.24 0.08'
  []
  [disp_y_p8_neg]
    type = PointValue
    variable = disp_y
    point = '0.235 -0.24 0.08'
  []

  [disp_z_p1_pos]
    type = PointValue
    variable = disp_z
    point = '-0.08 -0.08 0.24'
  []
  [disp_z_p1_neg]
    type = PointValue
    variable = disp_z
    point = '-0.08 -0.08 -0.24'
  []
  [disp_z_p2_pos]
    type = PointValue
    variable = disp_z
    point = '-0.08 0.08 0.24'
  []
  [disp_z_p2_neg]
    type = PointValue
    variable = disp_z
    point = '-0.08 0.08 -0.24'
  []
  [disp_z_p3_pos]
    type = PointValue
    variable = disp_z
    point = '0.08 -0.08 0.24'
  []
  [disp_z_p3_neg]
    type = PointValue
    variable = disp_z
    point = '0.08 -0.08 -0.24'
  []
  [disp_z_p4_pos]
    type = PointValue
    variable = disp_z
    point = '0.08 0.08 0.24'
  []
  [disp_z_p4_neg]
    type = PointValue
    variable = disp_z
    point = '0.08 0.08 -0.24'
  []
  [disp_z_p5_pos]
    type = PointValue
    variable = disp_z
    point = '0.235 0.08 0.24'
  []
  [disp_z_p5_neg]
    type = PointValue
    variable = disp_z
    point = '0.235 0.08 -0.24'
  []
  [disp_z_p6_pos]
    type = PointValue
    variable = disp_z
    point = '-0.235 0.08 0.24'
  []
  [disp_z_p6_neg]
    type = PointValue
    variable = disp_z
    point = '-0.235 0.08 -0.24'
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  line_search = none
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  start_time = 2419200 #28 days
  dt = 86400 #1 day in  sec
  automatic_scaling = true
  resid_vs_jac_scaling_param = 0.5
  end_time = 38880000 #450 days
  l_max_its = 10
  nl_max_its = 10
  nl_rel_tol = 1e-6
  # Because this problem is unrestrained, the displacement reference is 0,
  # so this controls the displacement convergence:
  nl_abs_tol = 1e-7
[]

[Outputs]
  perf_graph = true
  csv = true
  #exodus = true #Turned off to save space
[]

[Debug]
  show_var_residual_norms = true
[]
