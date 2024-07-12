program fcalc
    implicit none

    ! FLIGHT CALCULATOR
    ! FOR SIMULATION USE ONLY!
    ! WIP, accuracy not guaranteed
    ! Liam J <L.Jenny1@outlook.com>
    

    doubleprecision,parameter :: PI=atan(1.0d0)*4.0d0

    character(300) :: curl_command
    character(200) :: url_string
    character(100) :: input_string
    character(250) :: output_string
    character(30) :: filename

    integer :: selection
    integer :: status
    integer :: unit

    real :: dist
    real :: dist2

    call menu

    print *
    print *, 'EXECUTION COMPLETE'
    print *

    contains

    function appender(url_string,input_string) result(output_string)
        character(len=50) :: url_string
        character(len=150) :: output_string
        character(len=50) :: input_string
    
        !print *, 'APPENDER - NOTRIM:'//url_string
        !print *, 'APPENDER - NOTRIM:'//input_string
    
        output_string = trim(url_string) // trim(input_string)
     
        !print *, 'APPENDER - OUTPUT:'//output_string
    
    end function appender

    function file_new(filename, unit) result(status)
        character(30) :: filename
        integer :: status
        integer :: unit

        open(unit=unit, file=filename, status='new', action='write', form='formatted', iostat=status)
        if (status /= 0) then
            print *, 'Error opening file', trim(filename)
            stop 1
        end if
        close(unit)

        print *, trim(filename), 'created and written successfully'

    end function

    function file_open(filename, unit) result(status)
        character(30) :: filename
        integer :: status
        integer :: unit

        open(unit=unit, file=filename, status='old', action='write', form='formatted', iostat=status)
        if (status /= 0) then
            print *, 'Error opening file', trim(filename)
            stop 1
        end if

        print *, trim(filename), 'opened'

    end function

    function km_nm(dist) result(dist2)
        real :: dist
        real :: dist2

        dist2 = dist * 0.53995680

    end function

    function nm_km(dist) result(dist2)
        real :: dist
        real :: dist2

        dist2 = dist / 0.53995680

    end function
        
    function degree_radians(degree) result(radian)
        real :: degree
        real :: radian

        ! radian = degree * 3.14159265358979323846264338327 / 180
        radian = degree * PI / 180

    end function

    ! ========================================================================
    ! SUBROUTINES
    ! ========================================================================

    subroutine status_check(status)
        integer :: status
        integer :: status2
        if (status == 0) then
        else
            print *, 'CURL FAILURE'
        end if

    end subroutine

    subroutine METAR

        ! Pulls METAR from the NWS API using CURL
        
        print *, 'CURRENT WEATHER CONDITIONS - METAR'
        print *, 'Type IACO:'
        read (*,'(A)') input_string
        print *, ' '
    
        url_string =  'https://aviationweather.gov/api/data/metar?ids='
        output_string = appender(url_string,input_string)
        curl_command = "curl -X 'GET' " // output_string // "-H 'accept: */*'"
        
        status = system(curl_command)
        call status_check(status)
        
        call console
    end subroutine METAR
    
    subroutine TAF

        ! Pulls TAF from the NWS API using CURL
        
        print *, 'IACO WEATHER CONDITIONS - TAF'
        print *, 'Type IACO:'
        read (*,'(A)') input_string
        print *, ' '
    
        url_string =  'https://aviationweather.gov/api/data/taf?ids='
        output_string = appender(url_string,input_string)
        curl_command = "curl -X 'GET' " // output_string // "-H 'accept: */*'"
        
        status = system(curl_command)
        call status_check(status)
    
        call console
    end subroutine TAF

    subroutine AIRPORT_INFO
        
        print *, 'AIRPORT INFORMATION FETCH'
        print *, 'Type IACO:'
        read (*,'(A)') input_string
        print *, ' '
    
        url_string = 'https://nfdc.faa.gov/nfdcApps/services/ajv5/airportDisplay.jsp?airportId='
        output_string = appender(url_string,input_string)
        curl_command = "curl -s " // output_string // " >> " // input_string // ".html"
        print *, curl_command
        
        status = system(curl_command)
        call status_check(status)
    
        call console
    end subroutine AIRPORT_INFO

    subroutine DEAD
            integer :: gs
            integer :: time
            real :: estpos

            ! Distance calculator from last known point

            print *, 'DISTANCE CALCULATOR'
            print *, 'FROM LAST KNOWN POSITION'
            print *, 'Enter Ground Speed (knts):'
            read (*,*) gs
            print *, 'Enter Elapsed Time (Minutes):'
            read (*,*) time

            time = time / 60 
            estpos = gs * time

            print *, 'ESTIMATED DISTANCE FROM LAST KNOWN POSITION:', estpos, 'NM'

            call console
    end subroutine DEAD

    subroutine SORTER(selection)
        integer :: selection
        type :: t_intstr
            integer :: i
            character(len=10) :: c
        end type

        ! type(t_intstr), dimension(2) :: values(%i, %c)
        !values = [type(t_intstr) :: "1", "vspeed"]

     end subroutine   

    subroutine VSCALC
        integer :: tas
        integer :: vs

        ! Required vertical speed to maintain 3 degree descent at certain airspeed

        print *, 'Enter TAS: '
        read(*,*) tas

        vs = TAS * 3
        print *, 'Required Vertical Speed: ', vs

        call console
    end subroutine

    subroutine DESCENT
        integer :: start
        integer :: end
        real :: dist

        ! Descent calculator assuming 3 degree glideslope

        print *, 'Enter Starting Altitude:'
        read(*,*) start
        print *, 'Enter Desired Altitude:'
        read(*,*) end

        dist = ((start - end) / 1000) * 3

        !10 format(F6.1, a)
        !write (*, '(a, 1x, f5.1, a)') 'Descend at', dist, 'NM'
        print *, 'Descent at', dist, 'NM'
        
        call console
    end subroutine

    subroutine WIND_H
        integer :: wspeed_l
        integer :: wheading_metar
        integer :: heading
        real :: mhead
        real :: calc

        ! Calculate headwind

        print *, 'HEADWIND CALCULATOR'
        print *, 'Enter Wind Speed:'
        read (*,*) wspeed_l
        print *, 'Enter Wind Direction (METAR):'
        read (*,*) wheading_metar
        print *, 'Enter Aircraft Heading:'
        read (*,*) heading

        mhead = wheading_metar - heading
        calc = cos(mhead) * 8

        print *, "Headwind (KNTS):", calc
        call console
    end subroutine

    subroutine WIND_X
        integer :: wspeed_l
        integer :: wheading_metar
        integer :: heading
        real :: mhead
        real :: calc

        ! Calculate crosswind

        print *, 'CROSSWIND CALCULATOR'
        print *, 'Enter Wind Speed:'
        read (*,*) wspeed_l
        print *, 'Enter Wind Direction (METAR):'
        read (*,*) wheading_metar
        print *, 'Enter Aircraft Heading:'
        read (*,*) heading

        mhead = wheading_metar - heading
        calc = sin(mhead) * 8

        print *, "Crosswind (KNTS):", calc
        call console
    end subroutine

    subroutine FUEL_TO
        real :: distance 
        real :: speed    
        real :: hourly_burn_rate
        real :: estimated_time  
        real :: fuel_required

        ! Calculate time and fuel to destination
    
        print *, 'Enter the distance to the destination (NM):'
        read(*,*) distance
    
        print *, 'Enter the average speed (KTS):'
        read(*,*) speed
    
        print *, 'Enter the hourly fuel burn rate:'
        read(*,*) hourly_burn_rate
    
        estimated_time = distance / speed  ! Time in hours
   
        fuel_required = estimated_time * hourly_burn_rate
    
        print *, 'Estimated Time:', estimated_time, 'HR'
        print *, 'Fuel Required:', fuel_required
    
        call console
    end subroutine

    subroutine FUEL_BURN
        real :: ifuel
        real :: cfuel   
        real :: time
        real :: minburn 
        real :: hoburn

        ! Deduce minute and hourly fuel burnrate
    
        print *, 'Enter initial fuel quantity:'
        read(*,*) ifuel
    
        print *, 'Enter check fuel quanitity:'
        read(*,*) cfuel
    
        print *, 'Enter time elapsed(minutes):'
        read(*,*) time
    
        minburn = (ifuel - cfuel) / time
        hoburn = minburn * 60
    
        print *, 'Minute Burn Rate:', minburn, '/MIN'
        print *, 'Hourly Burn Rate:', hoburn, '/HR'
    
        call console
    end subroutine

    subroutine MPH2KNT
        integer :: airspeed
        integer :: knt

        print *, 'Enter Airspeed (MPH):'
        read(*,*) airspeed

        knt = airspeed / 1.15078

        print *, 'KNT:', knt
        call console
    end subroutine

    subroutine ROTTAS
        integer :: alt
        integer :: airspeed
        integer :: tas
        integer :: f1

        ! Take alititude and airspeed and roughly convert it to TAS

        print *, 'Enter Altitiude:'
        read(*,*) alt
        print *, 'Enter Airspeed:'
        read(*,*) airspeed

        f1 = (alt / 1000) * 0.02 
        tas = airspeed + (airspeed * f1)

        print *, 'Estimated TAS:', tas
        call console
    end subroutine

    subroutine CDF
        real :: coord_lat_curr
        real :: coord_lat_dest
        real :: coord_lon_curr
        real :: coord_lon_dest
        integer :: earthradius = 6371

        real :: p1, p2, p3 , p4, p5, p6, deltalat, deltalon
        real :: a, c, d 

        !
        ! I CURRENTLY HAVE NO IDEA WHAT I AM DOING HERE
        ! The end result will eventually be the ability to find a distance and bearing
        ! to another point on earth supllying only your coords and the desired coords
        !

        print *
        print *, 'COORDINATE LOCATION TOOL'
        print *, 'Enter Current Lattitude (XX.XX):'
        read(*,*) coord_lat_curr
        print *, 'Enter Current Longitude (XX.XX):'
        read(*,*) coord_lon_curr
        print *, 'Enter Desired Lattitude (XX.XX):'
        read(*,*) coord_lat_dest
        print *, 'Enter Desired Longitude (XX.XX):'
        read(*,*) coord_lon_dest

        ! Convert coordinates to radian and use haversine formula??

        coord_lat_curr = degree_radians(coord_lat_curr)
        coord_lon_curr = degree_radians(coord_lon_curr)
        coord_lat_dest = degree_radians(coord_lat_dest)
        coord_lon_dest = degree_radians(coord_lon_dest)

        deltalat = coord_lat_curr - coord_lat_dest
        deltalon = coord_lon_curr - coord_lon_dest

        p1 = deltalat / 2
        p2 = sin(p1) * sin(p1)
        p3 = cos(coord_lat_curr) * cos(coord_lat_dest)
        p4 = deltalon / 2
        p5 = sin(p4) * sin(p4)
        
        a = p2 + p3 + p5
        c = 2 * atan(sqrt(a) * sqrt(1 - a))
        d = earthradius * c 

        print *, 'CALCULATIONS'
        print *, 'Distance (NM):'
        print *, 'Bearing (DEG):'

        call console
    end subroutine

    subroutine clear
        status = system("clear")
        call console
    end subroutine clear

    subroutine menu
        print *
        print *, 'FLIGHT COMPUTER'
        print *
        print *, '1 - 3 Degree Slope VS'
        print *, '2 - Descent Timing'
        print *, '3 - INNACURACIES - Headwind Calc'
        print *, '4 - INNACURACIES - Crosswind Calc'
        print *, '5 - MPH > KNT'
        print *
        print *, '6 - Fuel Burn Calculator'
        print *, '7 - Time to + Fuel Required'
        print *, '8 - Dead Reckoning'
        print *, '9 - INCOMPLETE - Coordinate Direction Finder'
        print *
        print *, '10 - METAR'
        print *, '11 - TAF'
        print *, '12 - INCOMPLETE - Airport Information'
        print *, '13 - '
        print *
        print *, '14 - BROKEN - Estimated TAS'
        print *
        print *, '77 - Helptext'
        print *, '88 - Clear Screen'

        call console
    end subroutine menu

    subroutine console
        print *, '>> '
        read (*,*) selection

        if (selection == 1) then
            call VSCALC
        else if (selection == 2) then
            call DESCENT
        else if (selection == 3) then
            call WIND_H
        else if (selection == 4) then
            call WIND_X
        else if (selection == 5) then
            call MPH2KNT
        else if (selection == 6) then
            call FUEL_BURN
        else if (selection == 7) then
            call FUEL_TO
        else if (selection == 8) then
            call DEAD
        else if (selection == 9) then
            call CDF
        else if (selection == 10) then
            call METAR
        else if (selection == 11) then
            call TAF
        else if (selection == 12) then
            call AIRPORT_INFO
        else if (selection == 13) then
            call FUEL_BURN
        else if (selection == 15) then
            call ROTTAS
        else if (selection == 77) then
            call menu
        else if (selection == 88) then
            call clear
        end if

    end subroutine console

end program fcalc