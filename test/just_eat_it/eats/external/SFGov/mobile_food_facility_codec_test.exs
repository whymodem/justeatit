defmodule JustEatIt.Eats.External.SFGov.MobileFoodFacilityCodecTest do
  use ExUnit.Case, async: true
  alias JustEatIt.Eats.External.SFGov.MobileFoodFacilityCodec

  setup do
    json_path = "test/support/fixtures/eats/external/sf_food_facilities.json"

    {:ok, file} = File.read(json_path)
    {:ok, food_facility_json} = Jason.decode(file)
    {:ok, json: food_facility_json}
  end

  test "decodes JSON from https://data.sfgov.org/resource/rqzj-sfat.json", %{json: json} do
    food_facilities = MobileFoodFacilityCodec.decode(json)
    refute Enum.empty?(food_facilities)
    assert Enum.count(food_facilities) == 6

    facility = Enum.at(food_facilities, 0)
    assert facility.name == "Natan's Catering"
    assert facility.facility_type == :truck
    assert facility.latitude == Decimal.new("37.755030726766726")
    assert facility.longitude == Decimal.new("-122.38453073422282")
    assert facility.external_id == "1660525"
    assert facility.menu_description == "Burgers, melts, hot dogs, burritos,sandwiches, fries, onion rings, drinks"
    assert facility.address == "435 23RD ST"
  end

  test "decodes a single JSON record from https://data.sfgov.org/resource/rqzj-sfat.json" do
    sf_facility = %{
      ":@computed_region_bh8s_q3mv" => "28856",
      ":@computed_region_fyvs_ahh9" => "29",
      ":@computed_region_p5aj_wyqh" => "3",
      ":@computed_region_rxqg_mtj9" => "8",
      ":@computed_region_yftq_j783" => "10",
      "address" => "435 23RD ST",
      "applicant" => "Natan's Catering",
      "approved" => "2022-11-18T00:00:00.000",
      "block" => "4232",
      "blocklot" => "4232010",
      "cnn" => "1232000",
      "expirationdate" => "2023-11-15T00:00:00.000",
      "facilitytype" => "Truck",
      "fooditems" => "Burgers: melts: hot dogs: burritos:sandwiches: fries: onion rings: drinks",
      "latitude" => "37.755030726766726",
      "location" => %{
        "human_address" => "{\"address\": \"\", \"city\": \"\", \"state\": \"\", \"zip\": \"\"}",
        "latitude" => "37.755030726766726",
        "longitude" => "-122.38453073422282"
      },
      "longitude" => "-122.38453073422282",
      "lot" => "010",
      "objectid" => "1660525",
      "permit" => "22MFF-00073",
      "priorpermit" => "1",
      "received" => "20221118",
      "schedule" =>
        "http://bsm.sfdpw.org/PermitsTracker/reports/report.aspx?title=schedule&report=rptSchedule&params=permit=22MFF-00073&ExportPDF=1&Filename=22MFF-00073_schedule.pdf",
      "status" => "APPROVED",
      "x" => "6016887.317",
      "y" => "2102871.037"
    }

    facility = MobileFoodFacilityCodec.decode_food_facility(sf_facility)

    assert facility.name == "Natan's Catering"
    assert facility.facility_type == :truck
    assert facility.latitude == Decimal.new("37.755030726766726")
    assert facility.longitude == Decimal.new("-122.38453073422282")
    assert facility.external_id == "1660525"
    assert facility.menu_description == "Burgers, melts, hot dogs, burritos,sandwiches, fries, onion rings, drinks"
    assert facility.address == "435 23RD ST"
  end
end
