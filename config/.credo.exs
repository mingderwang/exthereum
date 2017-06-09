%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "tests/"],
        excluded: []
      },
      checks: [
        {Credo.Check.Consistency.TabsOrSpaces},
        {Credo.Check.Design.AliasUsage, priority: :low},
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 80},

        {Credo.Check.Design.TagTODO, exit_status: 2},
        {Credo.Check.Readability.ModuleDoc, false}
      ]
    }
  ]
}
