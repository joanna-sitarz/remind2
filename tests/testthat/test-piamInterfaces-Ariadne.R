library(gdx)

test_that("Test if REMIND reporting produces mandatory variables for Ariadne reporting", {
  skip_if_not(as.logical(gdxrrw::igdx(silent = TRUE)), "gdxrrw is not initialized properly")

  gdxPath <- file.path(tempdir(), "fulldata.gdx")

  utils::download.file("https://rse.pik-potsdam.de/data/example/remind2_test-Ariadne_fulldata.gdx",
                       gdxPath,
                       mode = "wb", quiet = TRUE
  )

  mif <- convGDX2MIF(gdxPath, gdx_ref = gdxPath)

  computedVariables <- getItems(mif, dim = 3.3)

  templateVariables <- piamInterfaces::getREMINDTemplateVariables("ARIADNE")

  expect_true(any(computedVariables %in% templateVariables))

  missingVariables <- setdiff(templateVariables, computedVariables)

  if (length(missingVariables) > 0) {
    warning(
      "The following variables are expected in the piamInterfaces package,
          but cannot be found in the reporting generated:\n ",
      paste(missingVariables, collapse = ",\n ")
    )
  }
  unlink(tempdir(), recursive = TRUE)
  tempdir(TRUE)
})
