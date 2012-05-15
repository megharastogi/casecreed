task :populate_geolocations_reverse => :environment do
  LawyerDetail.order("id DESC").all.each do |lawyer|
    p lawyer.id
    p "executing table transformations...total records are 18000 approx..keep counting.."

    if lawyer.latitude.nil? or lawyer.latitude==0 or lawyer.latitude=="0"
      p "fetching geolocations...:-( "
      a = Geocoder.fetch_coordinates(lawyer.address + " , " + lawyer.user.city.to_s +  " , " + lawyer.user.state.to_s)
      unless a.nil?
        p "got geolocations... :-) "
        lawyer.latitude=a[0]
        lawyer.longitude=a[1]
  p "saving geolocations...:-P "
      lawyer.save(false)
      end

    else
      p "Let me jump please...Jumped....:-)"
    end
  end
  p "transformation done... "

end

