!
! Copyright (C) 2002 FPMD group
! This file is distributed under the terms of the
! GNU General Public License. See the file `License'
! in the root directory of the present distribution,
! or http://www.gnu.org/copyleft/gpl.txt .
!

   MODULE read_namelists_module

!  this module handles the reading of input namelists
!  written by: Carlo Cavazzoni
!  --------------------------------------------------

        USE kinds

        USE parameters
        USE input_parameters

        USE constants, ONLY: factem, kb_au, au_kb, k_boltzman_au, angstrom_au, &
              uma_au, pi

        IMPLICIT NONE
        SAVE

        PRIVATE

        PUBLIC :: read_namelists

!  end of module-scope declarations
!  ----------------------------------------------

      CONTAINS

!=----------------------------------------------------------------------------=!
!
!  Variables initialization for Namelist CONTROL
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE control_defaults( prog )

        CHARACTER(LEN=2) :: prog  !  specify the calling program
        IF( prog == 'PW' ) THEN
          title = ' ' 
          calculation = 'scf' 
        ELSE
          title = 'MD Simulation' 
          calculation = 'cp' 
        END IF
        verbosity = 'default'
        IF( prog == 'PW' ) restart_mode = 'from_scratch' 
        IF( prog == 'CP' ) restart_mode = 'restart' 
        IF( prog == 'FP' ) restart_mode = 'restart' 
        nstep  = 50
        IF( prog == 'PW' ) iprint = 100000
        IF( prog == 'CP' ) iprint = 10
        IF( prog == 'FP' ) iprint = 10
        isave  = 100
        tstress = .FALSE.
        tprnfor = .FALSE.
        dt  = 1.0d0
        ndr = 50
        ndw = 50
        outdir = './'      ! use the path specified as Outdir and the filename prefix to store the output
        IF( prog == 'PW' ) prefix = 'pwscf'  
        IF( prog == 'CP' ) prefix = 'cp'  
        IF( prog == 'FP' ) prefix = 'cp'  
        IF( prog /= 'PW' ) pseudo_dir = './'  ! directory containing the pseudopotentials
        max_seconds   = 1.d+6
        ekin_conv_thr = 1.d-6
        etot_conv_thr = 1.d-4
        forc_conv_thr = 1.d-3
        disk_io = 'default'
        tefield = .FALSE.
        dipfield = .FALSE.
        lberry   = .FALSE.
        gdir     = 0
        nppstr   = 0
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Variables initialization for Namelist SYSTEM
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE system_defaults( prog )

        CHARACTER(LEN=2) :: prog  !  specify the calling program
        ibrav  = -1
        celldm = (/ 0.d0, 0.d0, 0.d0, 0.d0, 0.d0, 0.d0 /)
        a = 0.0d0 
        b = 0.0d0
        c = 0.0d0
        cosab = 0.0d0
        cosac = 0.0d0
        cosbc = 0.0d0
        nat    = 0
        ntyp   = 0
        nbnd   = 0
        nelec  = 0.d0
        ecutwfc = 0.d0
        ecutrho = 0.d0
        nr1  = 0
        nr2  = 0
        nr3  = 0
        nr1s = 0
        nr2s = 0
        nr3s = 0
        nr1b = 0
        nr2b = 0
        nr3b = 0
        occupations = 'fixed'
        smearing = 'gaussan'
        degauss = 0.d0
        ngauss  = 0
        nelup = 0.d0
        neldw = 0.d0
        nspin = 1
        IF( prog == 'PW' ) nosym = .FALSE.
        IF( prog == 'CP' ) nosym = .TRUE.
        IF( prog == 'FP' ) nosym = .TRUE.
        ecfixed = 0.d0
        qcutz   = 0.d0
        q2sigma = 0.01d0
        xc_type = 'PZ'
        starting_magnetization = 0.0d0
        lda_plus_U = .FALSE.
        Hubbard_U = 0.0d0
        Hubbard_alpha = 0.0d0
        edir = 1
        emaxpos = 0.5d0
        eopreg = 0.1d0
        eamp = 1.0d-3
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Variables initialization for Namelist ELECTRONS
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE electrons_defaults( prog )

        CHARACTER(LEN=2) :: prog  !  specify the calling program
        emass = 400.d0
        emass_cutoff = 2.5d0
        orthogonalization = 'ortho'
        ortho_eps = 1.d-8
        ortho_max = 20
        electron_maxstep = 100
        electron_dynamics = 'none' ! ( 'sd' | 'cg' | 'damp' | 'verlet' | 'none' | 'diis' )
        electron_damping = 0.1d0
        electron_velocities = 'default' ! ( 'zero' | 'default' )
        electron_temperature = 'not_controlled' ! ( 'nose' | 'not_controlled' | 'rescaling')
        ekincw = 0.001d0
        fnosee = 1.0d0
        ampre  = 0.0d0
        grease = 1.0d0
        IF( prog == 'FP' ) grease = 0.0d0
        twall  = .FALSE.
        IF( prog == 'PW' ) THEN
          startingwfc = 'atomic'
          startingpot = 'atomic'
        ELSE
          startingwfc = 'random'
          startingpot = ' '
        END IF
        conv_thr = 1.d-6
        empty_states_nbnd = 0
        empty_states_maxstep = 100
        empty_states_delt = 0.0d0
        empty_states_emass = 0.0d0
        empty_states_ethr = 0.0d0
        diis_size = 4
        diis_nreset = 3
        diis_hcut = 1.0d0
        diis_wthr = 0.0d0
        diis_delt = 0.0d0
        diis_maxstep = 100
        diis_rot = .FALSE.
        diis_fthr = 0.0d0
        diis_temp = 0.0d0
        diis_achmix = 0.0d0
        diis_g0chmix = 0.0d0
        diis_g1chmix = 0.0d0
        diis_nchmix = 3
        diis_nrot = 3
        diis_rothr  = 0.0d0
        diis_ethr   = 0.0d0
        diis_chguess = .FALSE.
        mixing_mode ='plain'
        IF( prog == 'FP' ) mixing_mode = ' '
        mixing_fixed_ns = 0
        mixing_beta = 0.7d0
        mixing_ndim = 8
        IF( prog == 'FP' ) mixing_ndim = 0
        diagonalization = ' '
        diago_cg_maxiter = 20
        IF( prog == 'FP' ) diago_cg_maxiter = 0
        diago_david_ndim = 4
        IF( prog == 'FP' ) diago_david_ndim = 0
        diago_diis_buff = 200
        IF( prog == 'FP' ) diago_diis_buff = 0
        diago_diis_ndim = 3
        IF( prog == 'FP' ) diago_diis_ndim = 0
        diago_diis_start = 2
        IF( prog == 'FP' ) diago_diis_start = 2
        diago_diis_keep = .FALSE.
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Variables initialization for Namelist IONS
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE ions_defaults( prog )

        CHARACTER(LEN=2) :: prog  !  specify the calling program
        ion_dynamics = 'none'  
        ! ( 'sd' | 'cg' | 'damp' | 'verlet' | 'none' )
        ! ( 'constrained-verlet' | 'bfgs' | 'constrained-bfgs' | 'beeman' )
        ion_radius = 0.5d0
        ion_damping = 0.1
        ion_positions = 'default' ! ( 'default' | 'from_input' )
        ion_velocities = 'default' ! ( 'zero' | 'default' | 'from_input' )
        ion_temperature = 'not_controlled' ! ( 'nose' | 'not_controlled' | 'rescaling' )
        tempw = 300.0d0
        fnosep = 1.0d0
        tranp = .FALSE.
        amprp = 0.0d0
        greasp = 1.0d0
        IF( prog == 'FP' ) greasp = 0.0d0
        tolp = 100.d0
        ion_nstepe = 1
        ion_maxstep = 100
        upscale = 0
        IF( prog == 'PW' ) upscale = 10
        potential_extrapolation = 'default'
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Variables initialization for Namelist CELL
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE cell_defaults( prog )

        CHARACTER(LEN=2) :: prog  !  specify the calling program
        cell_parameters = 'default' 
        cell_dynamics = 'none'      ! ( 'sd' | 'pr' | 'none' | 'w' | 'damp-pr' | 'damp-w' )
        cell_velocities = 'default' ! ( 'zero' | 'default' )
        press = 0.0d0
        wmass = 0.0d0
        cell_temperature = 'not_controlled' ! ( 'nose' | 'not_controlled' | 'rescaling' )
        temph = 0.0d0
        fnoseh = 1.0d0
        IF( prog == 'FP' ) fnoseh = 0.0d0
        greash = 1.0d0
        IF( prog == 'FP' ) greash = 0.0d0
        cell_dofree = 'all' ! ('all'* | 'volume' | 'x' | 'y' | 'z' | 'xy' | 'xz' | 'yz' | 'xyz' )
        cell_factor = 0.0d0
        cell_nstepe = 1
        cell_damping = 0.0d0
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Variables initialization for Namelist PHONON
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE phonon_defaults( prog )
        CHARACTER(LEN=2) :: prog  !  specify the calling program
        modenum = 0
        xqq = 0.0d0
        RETURN
      END SUBROUTINE
 
!=----------------------------------------------------------------------------=!
!
!  Broadcast variables values for Namelist CONTROL
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE control_bcast()
        USE io_global, ONLY: ionode_id
        USE mp, ONLY: mp_bcast
        CALL mp_bcast( title, ionode_id )
        CALL mp_bcast( calculation, ionode_id )
        CALL mp_bcast( verbosity, ionode_id )
        CALL mp_bcast( restart_mode, ionode_id )
        CALL mp_bcast( nstep, ionode_id )
        CALL mp_bcast( iprint, ionode_id )
        CALL mp_bcast( isave, ionode_id )
        CALL mp_bcast( tstress, ionode_id )
        CALL mp_bcast( tprnfor, ionode_id )
        CALL mp_bcast( dt, ionode_id )
        CALL mp_bcast( ndr, ionode_id )
        CALL mp_bcast( ndw, ionode_id )
        CALL mp_bcast( outdir, ionode_id )
        CALL mp_bcast( prefix, ionode_id )
        CALL mp_bcast( max_seconds, ionode_id )
        CALL mp_bcast( ekin_conv_thr, ionode_id )
        CALL mp_bcast( etot_conv_thr, ionode_id )
        CALL mp_bcast( forc_conv_thr, ionode_id )
        CALL mp_bcast( pseudo_dir, ionode_id )
        CALL mp_bcast( disk_io, ionode_id )
        CALL mp_bcast( tefield, ionode_id )
        CALL mp_bcast( dipfield, ionode_id )
        CALL mp_bcast( lberry, ionode_id )
        CALL mp_bcast( gdir, ionode_id )
        CALL mp_bcast( nppstr, ionode_id )
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Broadcast variables values for Namelist SYSTEM
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE system_bcast()
        USE io_global, ONLY: ionode_id
        USE mp, ONLY: mp_bcast
        CALL mp_bcast( ibrav, ionode_id  )
        CALL mp_bcast( celldm, ionode_id  )
        CALL mp_bcast( a, ionode_id )
        CALL mp_bcast( b, ionode_id )
        CALL mp_bcast( c, ionode_id )
        CALL mp_bcast( cosab, ionode_id )
        CALL mp_bcast( cosac, ionode_id )
        CALL mp_bcast( cosbc, ionode_id )
        CALL mp_bcast( nat, ionode_id  )
        CALL mp_bcast( ntyp, ionode_id  )
        CALL mp_bcast( nbnd, ionode_id  )
        CALL mp_bcast( nelec, ionode_id  )
        CALL mp_bcast( ecutwfc, ionode_id  )
        CALL mp_bcast( ecutrho, ionode_id  )
        CALL mp_bcast( nr1, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( nr2, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( nr3, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( nr1s, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( nr2s, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( nr3s, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( nr1b, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( nr2b, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( nr3b, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( occupations, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( smearing, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( degauss, ionode_id  )        ! not used in fpmd
        CALL mp_bcast( ngauss, ionode_id )        ! not used in fpmd
        CALL mp_bcast( nelup, ionode_id )
        CALL mp_bcast( neldw, ionode_id )
        CALL mp_bcast( nspin, ionode_id )
        CALL mp_bcast( nosym, ionode_id )
        CALL mp_bcast( ecfixed, ionode_id )
        CALL mp_bcast( qcutz, ionode_id )
        CALL mp_bcast( q2sigma, ionode_id )
        CALL mp_bcast( xc_type, ionode_id )
        CALL mp_bcast( nosym, ionode_id ) 
        CALL mp_bcast( starting_magnetization, ionode_id ) 
        CALL mp_bcast( lda_plus_U, ionode_id ) 
        CALL mp_bcast( Hubbard_U, ionode_id ) 
        CALL mp_bcast( Hubbard_alpha, ionode_id ) 
        CALL mp_bcast( edir, ionode_id )
        CALL mp_bcast( emaxpos, ionode_id )
        CALL mp_bcast( eopreg, ionode_id )
        CALL mp_bcast( eamp, ionode_id )
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Broadcast variables values for Namelist ELECTRONS
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE electrons_bcast()
        USE io_global, ONLY: ionode_id
        USE mp, ONLY: mp_bcast
        CALL mp_bcast( emass, ionode_id )
        CALL mp_bcast( emass_cutoff, ionode_id )
        CALL mp_bcast( orthogonalization, ionode_id )
        CALL mp_bcast( electron_maxstep, ionode_id )
        CALL mp_bcast( ortho_eps, ionode_id )
        CALL mp_bcast( ortho_max, ionode_id )
        CALL mp_bcast( electron_dynamics, ionode_id )
        CALL mp_bcast( electron_damping, ionode_id )
        CALL mp_bcast( electron_velocities, ionode_id )
        CALL mp_bcast( electron_temperature, ionode_id )
        CALL mp_bcast( conv_thr, ionode_id )
        CALL mp_bcast( ekincw, ionode_id )
        CALL mp_bcast( fnosee, ionode_id )
        CALL mp_bcast( startingwfc, ionode_id )
        CALL mp_bcast( ampre, ionode_id )
        CALL mp_bcast( grease, ionode_id )
        CALL mp_bcast( twall, ionode_id )
        CALL mp_bcast( startingpot, ionode_id )
        CALL mp_bcast( empty_states_nbnd, ionode_id )
        CALL mp_bcast( empty_states_maxstep, ionode_id )
        CALL mp_bcast( empty_states_delt, ionode_id )
        CALL mp_bcast( empty_states_emass, ionode_id )
        CALL mp_bcast( empty_states_ethr, ionode_id )
        CALL mp_bcast( diis_size, ionode_id )
        CALL mp_bcast( diis_nreset, ionode_id )
        CALL mp_bcast( diis_hcut, ionode_id )
        CALL mp_bcast( diis_wthr, ionode_id )
        CALL mp_bcast( diis_delt, ionode_id )
        CALL mp_bcast( diis_maxstep, ionode_id )
        CALL mp_bcast( diis_rot, ionode_id )
        CALL mp_bcast( diis_fthr, ionode_id )
        CALL mp_bcast( diis_temp, ionode_id )
        CALL mp_bcast( diis_achmix, ionode_id )
        CALL mp_bcast( diis_g0chmix, ionode_id )
        CALL mp_bcast( diis_g1chmix, ionode_id )
        CALL mp_bcast( diis_nchmix, ionode_id )
        CALL mp_bcast( diis_nrot, ionode_id )
        CALL mp_bcast( diis_rothr, ionode_id )
        CALL mp_bcast( diis_ethr, ionode_id )
        CALL mp_bcast( diis_chguess, ionode_id )
        CALL mp_bcast( mixing_fixed_ns, ionode_id )
        CALL mp_bcast( mixing_mode, ionode_id )
        CALL mp_bcast( mixing_beta, ionode_id )
        CALL mp_bcast( mixing_ndim, ionode_id )
        CALL mp_bcast( diagonalization, ionode_id )
        CALL mp_bcast( diago_cg_maxiter, ionode_id )
        CALL mp_bcast( diago_david_ndim, ionode_id )
        CALL mp_bcast( diago_diis_buff, ionode_id )
        CALL mp_bcast( diago_diis_ndim, ionode_id )
        CALL mp_bcast( diago_diis_start, ionode_id )
        CALL mp_bcast( diago_diis_keep, ionode_id )
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Broadcast variables values for Namelist IONS
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE ions_bcast()
        USE io_global, ONLY: ionode_id
        USE mp, ONLY: mp_bcast
        CALL mp_bcast( ion_dynamics, ionode_id )
        CALL mp_bcast( ion_radius, ionode_id )
        CALL mp_bcast( ion_damping, ionode_id )
        CALL mp_bcast( ion_positions, ionode_id )
        CALL mp_bcast( ion_velocities, ionode_id )
        CALL mp_bcast( ion_temperature, ionode_id )
        CALL mp_bcast( tempw, ionode_id )
        CALL mp_bcast( fnosep, ionode_id )
        CALL mp_bcast( tranp, ionode_id )
        CALL mp_bcast( amprp, ionode_id )
        CALL mp_bcast( greasp, ionode_id )
        CALL mp_bcast( tolp, ionode_id )
        CALL mp_bcast( ion_nstepe, ionode_id )
        CALL mp_bcast( ion_maxstep, ionode_id )
        CALL mp_bcast( upscale, ionode_id )
        CALL mp_bcast( potential_extrapolation, ionode_id )
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Broadcast variables values for Namelist CELL
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE cell_bcast()
        USE io_global, ONLY: ionode_id
        USE mp, ONLY: mp_bcast
        CALL mp_bcast( cell_parameters, ionode_id )
        CALL mp_bcast( cell_dynamics, ionode_id )
        CALL mp_bcast( cell_velocities, ionode_id )
        CALL mp_bcast( cell_dofree, ionode_id )
        CALL mp_bcast( press, ionode_id )
        CALL mp_bcast( wmass, ionode_id )
        CALL mp_bcast( cell_temperature, ionode_id )
        CALL mp_bcast( temph, ionode_id )
        CALL mp_bcast( fnoseh, ionode_id )
        CALL mp_bcast( cell_factor, ionode_id )
        CALL mp_bcast( cell_nstepe, ionode_id )
        CALL mp_bcast( cell_damping, ionode_id )
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Broadcast variables values for Namelist PHONON
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE phonon_bcast()
        USE io_global, ONLY: ionode_id
        USE mp, ONLY: mp_bcast
        CALL mp_bcast( modenum, ionode_id )
        CALL mp_bcast( xqq, ionode_id )
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Check input values for Namelist CONTROL
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE control_checkin( prog )
        CHARACTER(LEN=2) :: prog  !  specify the calling program
        CHARACTER(LEN=80) :: msg
        CHARACTER(LEN=20) :: sub_name = ' control_checkin '
        INTEGER :: i
        LOGICAL :: allowed = .FALSE.
        DO i = 1, SIZE(calculation_allowed)
          IF( TRIM(calculation) == calculation_allowed(i) ) allowed = .TRUE.
        END DO
        IF( .NOT. allowed ) &
          CALL errore( sub_name, ' calculation '''//TRIM(calculation)//''' not allowed ',-1)
        IF( calculation == ' ' ) &
          CALL errore( sub_name,' calculation not specifyed ',1)
        IF( prog == 'FP' ) THEN
          IF( calculation == 'nscf' .OR. calculation == 'phonon' ) &
            CALL errore( sub_name,' calculation '//calculation//' not implemented ',1)
        END IF
        IF( ndr < 50 ) &
          CALL errore( sub_name,' ndr out of range ',ndr)
        IF( ndw > 0 .AND. ndw < 50 ) &
          CALL errore( sub_name,' ndw out of range ',ndw)
        IF( nstep < 0 ) &
          CALL errore( sub_name,' nstep out of range ',nstep)
        IF( iprint < 1 ) &
          CALL errore( sub_name,' iprint out of range ',iprint)
        IF( isave < 1 ) &
          CALL errore( sub_name,' isave out of range ',isave)
        IF( dt < 0.0d0 ) &
          CALL errore( sub_name,' dt out of range ',-1)
        IF( max_seconds < 0.0d0 ) &
          CALL errore( sub_name,' max_seconds out of range ',-1)
        IF( ekin_conv_thr < 0.0d0 ) &
          CALL errore( sub_name,' ekin_conv_thr out of range ',-1)
        IF( etot_conv_thr < 0.0d0 ) &
          CALL errore( sub_name,' etot_conv_thr out of range ',-1)
        IF( forc_conv_thr < 0.0d0 ) &
          CALL errore( sub_name,' force_conv_thr out of range ',-1)
        IF( prog == 'FP' ) THEN
          IF( disk_io /= 'default' ) &
            CALL errore( sub_name,' disk_io not implemented yet ',-1)
        END IF
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Check input values for Namelist SYSTEM
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE system_checkin( prog )
        CHARACTER(LEN=2) :: prog  !  specify the calling program
        CHARACTER(LEN=80) :: msg
        CHARACTER(LEN=20) :: sub_name = ' system_checkin '

        IF( ibrav < 0 .OR. ibrav > 14 ) &
          CALL errore( sub_name ,' ibrav out of range ', MAX( 1, ibrav) )

        IF( ( ibrav /= 0 ) .AND. ( celldm(1) == 0.d0 ) .AND. ( a == 0.d0 ) ) &
           CALL errore(' iosys ',' invalid lattice parameters ( celldm or a )', 1 )

        IF( nat < 1 ) &
          CALL errore( sub_name ,' nat less than one ', MAX( nat, 1) )
        IF( nat > natx ) &
          CALL errore( sub_name ,' nat too large, increase NATX ', MAX( nat, 1) )

        IF( ntyp < 1 ) &
          CALL errore( sub_name ,' ntyp less than one ', MAX( ntyp, 1) )
        IF( ntyp < 1 .OR. ntyp > nsx ) &
          CALL errore( sub_name ,' ntyp too large, increase NSX ', MAX( ntyp, 1) )

        IF( prog /= 'PW' ) THEN
          IF( nbnd < 1 .OR. nbnd > nbndxx ) &
            CALL errore( sub_name ,' nbnd out of range ', MAX(nbnd, 1) )
          IF( nelec <= 0.d0 .OR. nelec > 2*nbnd ) &
            CALL errore( sub_name ,' nelec out of range ', MAX(int(nelec), 1) )
        END IF

        IF( nspin < 1 .OR. nspin > nspinx ) &
          CALL errore( sub_name ,' nspin out of range ', MAX(nspin, 1 ) )

        IF( ecutwfc <= 0.0d0 ) &
          CALL errore( sub_name ,' ecutwfc out of range ',1)
        IF( ecutrho < 0.0d0 ) &
          CALL errore( sub_name ,' ecutrho out of range ',1)

        IF( prog == 'FP' ) THEN
          IF( nr1 /= 0 ) &
            CALL errore( sub_name ,' nr1 is not used in FPMD ',-1)
          IF( nr2 /= 0 ) &
            CALL errore( sub_name ,' nr2 is not used in FPMD ',-1)
          IF( nr3 /= 0 ) &
            CALL errore( sub_name ,' nr3 is not used in FPMD ',-1)
          IF( nr1s /= 0 ) &
            CALL errore( sub_name ,' nr1s is not used in FPMD ',-1)
          IF( nr2s /= 0 ) &
            CALL errore( sub_name ,' nr2s is not used in FPMD ',-1)
          IF( nr3s /= 0 ) &
            CALL errore( sub_name ,' nr3s is not used in FPMD ',-1)
          IF( nr1b /= 0 ) &
            CALL errore( sub_name ,' nr1b is not used in FPMD ',-1)
          IF( nr2b /= 0 ) &
            CALL errore( sub_name ,' nr2b is not used in FPMD ',-1)
          IF( nr3b /= 0 ) &
            CALL errore( sub_name ,' nr3b is not used in FPMD ',-1)
          IF( degauss /= 0.0d0 ) &
            CALL errore( sub_name ,' degauss is not used in FPMD ',-1)
          IF( ngauss /= 0 ) &
            CALL errore( sub_name ,' ngauss is not used in FPMD ',-1)
        END IF
        IF( nelup < 0.d0 .OR. nelup > nelec ) &
          CALL errore( sub_name ,' nelup out of range ',-1)
        IF( neldw < 0.d0 .OR. neldw > nelec ) &
          CALL errore( sub_name ,' neldw out of range ',-1)
        IF( ecfixed < 0.0d0 ) &
          CALL errore( sub_name ,' ecfixed out of range ',-1)
        IF( qcutz < 0.0d0 ) &
          CALL errore( sub_name ,' qcutz out of range ',-1)
        IF( q2sigma < 0.0d0 ) &
          CALL errore( sub_name ,' q2sigma out of range ',-1)
        IF( prog == 'FP' ) THEN
          IF( ANY(starting_magnetization /= 0.0d0) ) &
            CALL errore( sub_name ,' starting_magnetization is not used in FPMD ',-1)
          IF( lda_plus_U ) &
            CALL errore( sub_name ,' lda_plus_U is not used in FPMD ',-1)
          IF( ANY(Hubbard_U /= 0.0d0) ) &
            CALL errore( sub_name ,' Hubbard_U is not used in FPMD ',-1)
          IF( ANY(Hubbard_alpha /= 0.0d0) ) &
            CALL errore( sub_name ,' Hubbard_alpha is not used in FPMD ',-1)
          IF( nosym ) &
            CALL errore( sub_name ,' nosym not implemented in FPMD ',-1)
        END IF
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Check input values for Namelist ELECTRONS
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE electrons_checkin( prog )
        CHARACTER(LEN=2) :: prog  !  specify the calling program
        CHARACTER(LEN=80) :: msg
        CHARACTER(LEN=20) :: sub_name = ' electrons_checkin '
        INTEGER :: i
        LOGICAL :: allowed = .FALSE.
        DO i = 1, SIZE(electron_dynamics_allowed)
          IF( TRIM(electron_dynamics) == electron_dynamics_allowed(i) ) allowed = .TRUE.
        END DO
        IF( .NOT. allowed ) &
          CALL errore( sub_name, ' electron_dynamics '''//TRIM(electron_dynamics)//''' not allowed ',-1)
        IF( emass <= 0.0d0 ) &
          CALL errore( sub_name, ' emass less or equal 0 ',-1)
        IF( emass_cutoff <= 0.0d0 ) &
          CALL errore( sub_name, ' emass_cutoff less or equal 0 ',-1)
        IF( ortho_eps <= 0.0d0 ) &
          CALL errore( sub_name, ' ortho_eps less or equal 0 ',-1)
        IF( ortho_max < 1 ) &
          CALL errore( sub_name, ' ortho_max less than 1 ',-1)
        IF( fnosee <= 0.0d0 ) &
          CALL errore( sub_name, ' fnosee less or equal 0 ',-1)
        IF( ekincw <= 0.0d0 ) &
          CALL errore( sub_name, ' ekincw less or equal 0 ',-1)
        IF( prog == 'FP' ) THEN
          IF( grease /= 0.0d0 ) &
            CALL errore( sub_name, ' grease not used in FPMD ',-1)
          IF( twall ) &
            CALL errore( sub_name, ' twall not used in FPMD ',-1)
        END IF
        IF( empty_states_nbnd < 0 ) &
          CALL errore( sub_name, ' invalid empty_states_nbnd, less than 0 ',-1)
        IF( empty_states_maxstep < 0 ) &
          CALL errore( sub_name, ' invalid empty_states_maxstep, less than 0 ',-1)
        IF( empty_states_delt < 0.0d0 ) &
          CALL errore( sub_name, ' invalid empty_states_delt, less than 0 ',-1)
        IF( empty_states_emass < 0.0d0 ) &
          CALL errore( sub_name, ' invalid empty_states_emass, less than 0 ',-1)
        IF( empty_states_ethr < 0.0d0 ) &
          CALL errore( sub_name, ' invalid empty_states_ethr, less than 0 ',-1)
        IF( prog == 'FP' ) THEN
          IF( mixing_mode /= ' ' ) &
            CALL errore( sub_name, ' mixing_mode not used in FPMD ',-1)
          IF( mixing_fixed_ns /= 0 ) &
            CALL errore( sub_name, ' mixing_fixed_ns not used in FPMD ',-1)
          IF( mixing_beta /= 0.0d0 ) &
            CALL errore( sub_name, ' mixing_beta not used in FPMD ',-1)
          IF( mixing_ndim /= 0 ) &
            CALL errore( sub_name, ' mixing_ndim not used in FPMD ',-1)
          IF( diago_cg_maxiter /= 0 ) &
            CALL errore( sub_name, ' diago_cg_maxiter not used in FPMD ',-1)
          IF( diago_david_ndim /= 0 ) &
            CALL errore( sub_name, ' diago_david_ndim not used in FPMD ',-1)
          IF( diago_diis_buff /= 0 ) &
            CALL errore( sub_name, ' diago_diis_buff not used in FPMD ',-1)
          IF( diago_diis_ndim /= 0 ) &
            CALL errore( sub_name, ' diago_diis_buff not used in FPMD ',-1)
          IF( diago_diis_start /= 0 ) &
            CALL errore( sub_name, ' diago_diis_start not used in FPMD ',-1)
          IF( diago_diis_keep ) &
            CALL errore( sub_name, ' diago_diis_keep not used in FPMD ',-1)
          IF( diagonalization /= ' ' ) &
            CALL errore( sub_name, ' diagonalization not used in FPMD ',-1)
          IF( startingpot /= ' ' ) &
            CALL errore( sub_name, ' startingpot not used in FPMD ',-1)
        END IF
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Check input values for Namelist IONS
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE ions_checkin( prog )
        CHARACTER(LEN=2) :: prog  !  specify the calling program
        CHARACTER(LEN=80) :: msg
        CHARACTER(LEN=20) :: sub_name = ' ions_checkin '
        INTEGER :: i
        LOGICAL :: allowed = .FALSE.
        DO i = 1, SIZE(ion_dynamics_allowed)
          IF( TRIM(ion_dynamics) == ion_dynamics_allowed(i) ) allowed = .TRUE.
        END DO
        IF( .NOT. allowed ) &
          CALL errore( sub_name, ' ion_dynamics '''//TRIM(ion_dynamics)//''' not allowed ',-1)
        IF( tempw <= 0.0d0 ) &
          CALL errore( sub_name,' tempw out of range ',-1)
        IF( fnosep <= 0.0d0 ) &
          CALL errore( sub_name,' fnosep out of range ',-1)
        IF( ion_nstepe <= 0 ) &
          CALL errore( sub_name,' ion_nstepe out of range ',-1)
        IF( ion_maxstep < 0 ) &
          CALL errore( sub_name,' ion_maxstep out of range ',-1)
        IF( prog == 'FP' ) THEN
          IF( upscale /= 0 ) &
            CALL errore( sub_name,' upscale not used in FPMD ',-1)
          IF( potential_extrapolation /= 'default' ) &
            CALL errore( sub_name,' potential_extrapolation not used in FPMD ',-1)
          IF( greasp /= 0.0d0 ) &
            CALL errore( sub_name,' greasp not used in FPMD ',-1)
        END IF
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Check input values for Namelist CELL
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE cell_checkin( prog )
        CHARACTER(LEN=2) :: prog  !  specify the calling program
        CHARACTER(LEN=80) :: msg
        CHARACTER(LEN=20) :: sub_name = ' cell_checkin '
        INTEGER :: i
        LOGICAL :: allowed = .FALSE.
        DO i = 1, SIZE(cell_dynamics_allowed)
          IF( TRIM(cell_dynamics) == cell_dynamics_allowed(i) ) allowed = .TRUE.
        END DO
        IF( .NOT. allowed ) &
          CALL errore( sub_name, ' cell_dynamics '''//TRIM(cell_dynamics)//''' not allowed ',-1)
        IF( wmass < 0.0d0 ) &
          CALL errore( sub_name,' wmass out of range ',-1)
        IF( prog == 'FP' ) THEN
          IF( temph /= 0.0d0 ) &
            CALL errore( sub_name,' temph not used in FPMD ',-1)
          IF( fnoseh /= 0.0d0 ) &
            CALL errore( sub_name,' fnoseh not used in FPMD ',-1)
          IF( greash /= 0.0d0 ) &
            CALL errore( sub_name,' greash not used in FPMD ',-1)
          IF( cell_factor /= 0.0d0 ) &
            CALL errore( sub_name,' cell_factor not used in FPMD ',-1)
        END IF
        IF( cell_nstepe <= 0 ) &
          CALL errore( sub_name,' cell_nstepe out of range ',-1)
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Check input values for Namelist PHONON
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE phonon_checkin( prog )
        CHARACTER(LEN=2) :: prog  !  specify the calling program
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Set values according to the "calculation" variable
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE fixval( prog )

        CHARACTER(LEN=2) :: prog  !  specify the calling program

        CHARACTER(LEN=80) :: msg
        CHARACTER(LEN=20) :: sub_name = ' fixval '

        IF( prog == 'PW' ) startingpot = 'atomic'

        SELECT CASE ( TRIM(calculation) )
          CASE ('scf')
            IF( prog == 'FP' ) THEN
              electron_dynamics = 'sd'
              ion_dynamics = 'none'
              cell_dynamics = 'none'
            END IF
            IF( prog == 'CP' ) THEN
              electron_dynamics = 'damp'
              ion_dynamics = 'none'
              cell_dynamics = 'none'
            END IF
          CASE ('nscf')
            IF( prog == 'FP' ) CALL errore( sub_name,' calculation '//calculation//' not implemented ',1)
            IF( prog == 'CP' ) occupations = 'bogus'
            IF( prog == 'CP' ) electron_dynamics = 'damp'
            IF( prog == 'PW' ) startingpot = 'file'
          CASE ('phonon')
            IF( prog == 'FP' ) CALL errore( sub_name,' calculation '//calculation//' not implemented ',1)
            IF( prog == 'CP' ) CALL errore( sub_name,' calculation '//calculation//' not implemented ',1)
            IF( prog == 'PW' ) startingpot = 'file'
          CASE ('relax')
            IF( prog == 'FP' ) THEN
              electron_dynamics = 'sd'
              ion_dynamics = 'damp'
            ELSE IF( prog == 'CP' ) THEN
              electron_dynamics = 'damp'
              ion_dynamics = 'damp'
            ELSE IF( prog == 'PW' ) THEN
              ion_dynamics = 'bfgs'
            END IF
          CASE ( 'md', 'cp' )
            IF( prog == 'FP' .OR. prog == 'CP' ) THEN
              electron_dynamics = 'verlet'
              ion_dynamics = 'verlet'
            ELSE IF( prog == 'PW' ) THEN
              ion_dynamics = 'verlet'
            END IF
          CASE ('vc-relax')
            IF( prog == 'FP' ) THEN
              electron_dynamics = 'sd'
              ion_dynamics = 'damp'
              cell_dynamics = 'pr'
            ELSE IF( prog == 'CP' ) THEN
              electron_dynamics = 'damp'
              ion_dynamics = 'damp'
              cell_dynamics = 'damp-pr'
            ELSE IF( prog == 'PW' ) THEN
              ion_dynamics = 'damp'
            END IF
          CASE ( 'vc-md', 'vc-cp' )
            IF( prog == 'FP' .OR. prog == 'CP' ) THEN
              electron_dynamics = 'verlet'
              ion_dynamics = 'verlet'
              cell_dynamics = 'pr'
            ELSE IF( prog == 'PW' ) THEN
              ion_dynamics = 'beeman'
            END IF
          CASE DEFAULT
            CALL errore( sub_name,' calculation '//calculation//' not implemented ',1)
        END SELECT
        RETURN
      END SUBROUTINE

!=----------------------------------------------------------------------------=!
!
!  Namelist parsing main routine
!
!=----------------------------------------------------------------------------=!

      SUBROUTINE read_namelists( prog )

!  this routine reads data from standard input and puts them into
!  module-scope variables (accessible from other routines by including
!  this module, or the one that contains them)
!  ----------------------------------------------

! ...   declare modules

        USE mp_global, ONLY: mpime, nproc, group
        USE io_global, ONLY: ionode, ionode_id
        USE mp, ONLY: mp_bcast

        IMPLICIT NONE

! ...   Declare Variables

        CHARACTER(LEN=2) :: prog  !  specify the calling program
                                  !  prog = 'PW'  pwscf
                                  !  prog = 'FP'  fpmd
                                  !  prog = 'CP'  cpr

! ...   declare other variables
        INTEGER :: ios

! ...   end of declarations
!  ----------------------------------------------

        IF( prog /= 'PW' .AND. prog /= 'CP' .AND. prog /= 'FP' ) &
          CALL errore( ' read_namelists ', ' unknown calling program ', 1 )

! ...   Here set default values for namelists

        CALL control_defaults( prog )
        CALL system_defaults( prog )
        CALL electrons_defaults( prog )
        CALL ions_defaults( prog )
        CALL cell_defaults( prog )
        CALL phonon_defaults( prog )
!
! ...   Here start reading standard input file
        ios = 0
        IF( ionode ) THEN
          READ (5, control, iostat = ios ) 
        END IF
        CALL mp_bcast( ios, ionode_id )
        IF( ios /= 0 ) THEN
          CALL errore( ' read_namelists ', ' reading namelist control ', ABS(ios) )
        END IF

        CALL control_bcast( )
        CALL control_checkin( prog )

        CALL fixval( prog )


        ios = 0
        IF( ionode ) THEN
          READ (5, system, iostat = ios ) 
        END IF
        CALL mp_bcast( ios, ionode_id )
        IF( ios /= 0 ) THEN
          CALL errore( ' read_namelists ', ' reading namelist system ', ABS(ios) )
        END IF

        CALL system_bcast( )
        CALL system_checkin( prog )


        ios = 0
        IF( ionode ) THEN
          READ (5, electrons, iostat = ios ) 
        END IF
        CALL mp_bcast( ios, ionode_id )
        IF( ios /= 0 ) THEN
          CALL errore( ' read_namelists ', ' reading namelist electrons ', ABS(ios) )
        END IF

        CALL electrons_bcast( )
        CALL electrons_checkin( prog )


        ios = 0
        IF( ionode ) THEN
          IF( TRIM(calculation) == 'relax'   .or. TRIM(calculation) == 'md'   .or.&
              TRIM(calculation) == 'vc-relax'.or. TRIM(calculation) == 'vc-md'.or.&
              TRIM(calculation) == 'cp' .or. TRIM(calculation) == 'vc-cp' ) THEN
            READ (5, ions, iostat = ios ) 
          END IF
        END IF
        CALL mp_bcast( ios, ionode_id )
        IF( ios /= 0 ) THEN
          CALL errore( ' read_namelists ', ' reading namelist ions ', ABS(ios) )
        END IF

        CALL ions_bcast( )
        CALL ions_checkin( prog )

        ios = 0
        IF( ionode ) THEN
          IF( TRIM( calculation ) == 'vc-relax' .OR. TRIM( calculation ) == 'vc-cp' .OR. &
              TRIM(calculation) == 'vc-md' .OR. TRIM( calculation ) == 'vc-md' ) THEN
            READ (5, cell, iostat = ios ) 
          END IF
        END IF
        CALL mp_bcast( ios, ionode_id )
        IF( ios /= 0 ) THEN
          CALL errore( ' read_namelists ', ' reading namelist cell ', ABS(ios) )
        END IF

        CALL cell_bcast()
        CALL cell_checkin( prog )


        ios = 0
        IF( ionode ) THEN
          IF( TRIM( calculation ) == 'phonon' ) THEN
            READ (5, phonon, iostat = ios )
          END IF
        END IF
        CALL mp_bcast( ios, ionode_id )
        IF( ios /= 0 ) THEN
          CALL errore( ' read_namelists ', ' reading namelist cell ', ABS(ios) )
        END IF

        CALL phonon_bcast()
        CALL phonon_checkin( prog )

        RETURN
      END SUBROUTINE read_namelists


   END MODULE read_namelists_module
