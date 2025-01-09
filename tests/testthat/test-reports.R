td <- tempdir()
test_path <- file.path(td,'test')
init_workspace(path = test_path, restart = FALSE)

testthat::describe("create project", {

  it('root list files',{
    testthat::expect_equal(
      list.files(file.path(test_path)),
        c("data", "deliv", "references", "renv","renv.lock", "script", "test.Rproj")
      )
  })

})
