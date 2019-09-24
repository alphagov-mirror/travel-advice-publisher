feature "Country Index" do
  before :each do
    login_as_stub_user
    @countries = YAML.load_file(Rails.root.join("spec/fixtures/data/countries.yml"))
  end

  scenario "inspecting the country index" do
    create(:draft_travel_advice_edition, country_slug: "albania")
    create(:published_travel_advice_edition, country_slug: "algeria")
    create(:archived_travel_advice_edition, country_slug: "angola")

    create(:published_travel_advice_edition, country_slug: "aruba")
    create(:draft_travel_advice_edition, country_slug: "aruba")

    create(:archived_travel_advice_edition, country_slug: "afghanistan")
    create(:archived_travel_advice_edition, country_slug: "afghanistan")
    create(:published_travel_advice_edition, country_slug: "afghanistan")
    create(:draft_travel_advice_edition, country_slug: "afghanistan")

    create(:published_travel_advice_edition, country_slug: "austria")
    create(:archived_travel_advice_edition, country_slug: "austria")

    visit "/admin/countries"

    rows = page.all("table tbody tr").map { |r| r.all("th, td").map(&:text).map(&:strip) }
    expect(rows).to eq([
      ["Afghanistan",         "advice published"],
      ["Albania",             "no advice published"],
      ["Algeria",             "advice published"],
      ["Andorra",             "no advice published"],
      ["Angola",              "no advice published"],
      ["Anguilla",            "no advice published"],
      ["Antigua and Barbuda", "no advice published"],
      ["Argentina",           "no advice published"],
      ["Armenia",             "no advice published"],
      ["Aruba",               "advice published"],
      ["Australia",           "no advice published"],
      ["Austria",             "advice published"],
      ["Azerbaijan",          "no advice published"],
    ])
  end
end
