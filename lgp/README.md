lgp Cookbook
============
TODO: Basic configuration for the LGP application


Requirements
------------
### cookbooks
- `database` cookbook

Attributes
----------
None for now

e.g.
#### lgp::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['lgp']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### lgp::default
Just include `lgp` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[lgp]"
  ]
}
```
