package authopa
import input
<<<<<<< HEAD
=======
# import data.cjson
# import data.kong

>>>>>>> b24d1d77c78659ffe1fd7978439dcc0a8a8428bd
opa_policy = [
    {
        "path": "/demo",
        "method": "GET",
        "allowed_roles": ["Moderator"]
    }

]

default allow = false 
<<<<<<< HEAD
=======


>>>>>>> b24d1d77c78659ffe1fd7978439dcc0a8a8428bd
allow {
    some rule
    rule = opa_policy[_]
    rule.path == input.requestPath
<<<<<<< HEAD
    rule.method == input.requestMethod 
    any_role_allowed(rule.allowed_roles)

}
any_role_allowed(allowed_roles) {
    has_common_role(input.userRoles, allowed_roles)
}
=======
    rule.method == input.requestMethod

    # print("Checking rule for path:", rule.path)
    # print("Checking rule for method:", rule.method)
    # print("Checking roles:", input.userRoles)
    
    any_role_allowed(rule.allowed_roles)

}

# You might have additional rules for other policy checks here

# Define a rule to allow access based on user roles and matched policy
# any_role_allowed(allowed_roles) {
#     role := input.userRoles[_]
#     role == allowed_roles[_]
# }
any_role_allowed(allowed_roles) {
    has_common_role(input.userRoles, allowed_roles)
}

>>>>>>> b24d1d77c78659ffe1fd7978439dcc0a8a8428bd
has_common_role(roles1, roles2) {
    some role1
    role1 = roles1[_]
    role1_allowed(role1, roles2)
}
<<<<<<< HEAD
=======

>>>>>>> b24d1d77c78659ffe1fd7978439dcc0a8a8428bd
role1_allowed(role1, roles2) {
    some role2
    role2 = roles2[_]
    role1 == role2
}