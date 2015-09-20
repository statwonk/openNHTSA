library("openNHSTA")

context("query-builder")
test_that("build facility query", {
  df <- facility("complaints") %>%
    nhsta_fetch()

  expect_that(df, is_a("data.frame"))
  expect_that(df$ModelYear, is_a("character"))
})

test_that("build modelyear query", {
  df <- facility("complaints") %>%
    model_year("2010") %>%
    nhsta_fetch()

  expect_that(df, is_a("data.frame"))
  expect_that(names(df), testthat::equals(c("ModelYear", "Make")))
})

test_that("build vehicle make query", {
  df <- facility("complaints") %>%
    model_year("2010") %>%
    vehicle_make("ford") %>%
    nhsta_fetch()

  expect_that(df, is_a("data.frame"))
  expect_that(names(df), testthat::equals(c("ModelYear", "Make", "Model")))
})

test_that("build vehicle model query", {
  df <- facility("complaints") %>%
    model_year("2010") %>%
    vehicle_make("ford") %>%
    vehicle_model("fusion") %>%
    nhsta_fetch()

  expect_that(df, is_a("data.frame"))
  expect_that(all(c("ODINumber", "Manufacturer", "Crash",
                    "Fire", "NumberOfInjured", "NumberOfDeaths",
                    "DateofIncident", "DateComplaintFiled", "VIN",
                    "Component", "Summary", "ProductType", "ModelYear",
                    "Make", "Model") %in% names(df)), is_true())
})
