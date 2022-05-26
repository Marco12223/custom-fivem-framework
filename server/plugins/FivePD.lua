FivePD_API = {}

function FivePD_API.GetFivePDUser(ServerPlayerId)

    local identifier = Framework.GetIdentifier(ServerPlayerId)

    MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @license', {['@license'] = identifier}, function(result)

        if #result ~= 0 then

            return result[1]

        else

            return false

        end

    end)

end

function FivePD_API.GetFivePDUserByIdentifier(identifier)

    MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @license', {['@license'] = identifier}, function(result)

        if #result ~= 0 then

            return result[1]

        else

            return false

        end


    end)

end

function FivePD_API.GetDepartmentMembers()

    MySQL.Async.fetchAll('SELECT * FROM department_members', {}, function(result)

        if #result ~= 0 then

            return result

        else

            return false

        end

    end)

end

function FivePD_API.GetDepartmentMembersInDepartment(deptId)

    MySQL.Async.fetchAll('SELECT * FROM department_members WHERE id = @deptId', {['@deptId'] = deptId}, function(result)

        if #result ~= 0 then

            return result[1]

        else

            return false

        end

    end)

end

function FivePD_API.GetDepartments()

    MySQL.Async.fetchAll('SELECT * FROM departments', {}, function(result)

        if #result ~= 0 then

            return result[1]

        else

            return false

        end

    end)

end

function FivePD_API.GetDepartment(deptId)

    MySQL.Async.fetchAll('SELECT * FROM departments WHERE id = @deptID', {['@deptID'] = deptId}, function(result)

        if #result ~= 0 then

            return result[1]

        else

            return false

        end

    end)

end

function FivePD_API.GetDepartmentByShortname(shortname)

    MySQL.Async.fetchAll('SELECT * FROM departments WHERE shortname = @shortname', {['@shortname'] = shortname}, function(result)

        if #result ~= 0 then

            return result[1]

        else

            return false

        end

    end)

end

function FivePD_API.isPlayerInDepartment(ServerPlayerId, deptId)

    local FivePDUser = FivePD_API.GetFivePDUser(ServerPlayerId)
    local FivePDUserId = FivePDUser.id
    local FivePDDeptMembers = FivePD_API.GetDepartmentMembersInDepartment(deptId)

    for i=1, #FivePDDeptMembers, 1 do

        if FivePDDeptMembers[i].userID == FivePDUserId then

            return true

        else

            return false

        end

    end

end

function FivePD_API.GetDepartmentMember(ServerPlayerId, deptId)

    MySQL.Async.fetchAll('SELECT * FROM department_members WHERE id = @deptId AND userID = @userId', {['@deptId'] = deptId, ['@userID'] = ServerPlayerId}, function(result)

        if #result ~= 0 then

            return result[1]

        else

            return false

        end

    end)

end

------------------------------------------------------------------------------------------
------------------------------                          ----------------------------------
------------------------------      ServerCallbacks     ----------------------------------
------------------------------                          ----------------------------------
------------------------------------------------------------------------------------------

Framework.RegisterServerCallback('Framework:FivePD:GetFivePDUser', function(source, cb)

    local identifier = Framework.GetIdentifier(source)

    MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @license', {['@license'] = identifier}, function(result)

        if #result ~= 0 then

            cb(result[1])

        else

            cb(false)

        end


    end)

end)

Framework.RegisterServerCallback('Framework:FivePD:GetFivePDUserByIdentifier', function(source, cb, identifier)

    MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @license', {['@license'] = identifier}, function(result)

        if #result ~= 0 then

            cb(result[1])

        else

            cb(false)

        end


    end)

end)

Framework.RegisterServerCallback('Framework:FivePD:GetDepartmentMembers', function(source, cb)

    MySQL.Async.fetchAll('SELECT * FROM department_members', {}, function(result)

        if #result ~= 0 then

            cb(result)

        else

            cb(false)

        end

    end)

end)

Framework.RegisterServerCallback('Framework:FivePD:GetDepartmentMembersInDepartment', function(source, cb, deptId)

    MySQL.Async.fetchAll('SELECT * FROM department_members WHERE id = @deptId', {['@deptId'] = deptId}, function(result)

        if #result ~= 0 then

            cb(result[1])

        else

            cb(false)

        end

    end)

end)

Framework.RegisterServerCallback('Framework:FivePD:GetDepartments', function(source, cb)

    MySQL.Async.fetchAll('SELECT * FROM departments', {}, function(result)

        if #result ~= 0 then

            cb(result[1])

        else

            cb(false)

        end

    end)

end)

Framework.RegisterServerCallback('Framework:FivePD:GetDepartment', function(source, cb, deptId)

    MySQL.Async.fetchAll('SELECT * FROM departments WHERE id = @deptID', {['@deptID'] = deptId}, function(result)

        if #result ~= 0 then

            cb(result[1])

        else

            cb(false)

        end

    end)

end)

Framework.RegisterServerCallback('Framework:FivePD:GetDepartmentByShortname', function(source, cb, shortname)

    MySQL.Async.fetchAll('SELECT * FROM departments WHERE shortname = @shortname', {['@shortname'] = shortname}, function(result)

        if #result ~= 0 then

            cb(result[1])

        else

            cb(false)

        end

    end)

end)

Framework.RegisterServerCallback('Framework:FivePD:GetDepartmentByShortname', function(source, cb, deptId)

    local identifier = Framework.GetIdentifier(source)

    MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @license', {['@license'] = identifier}, function(result)

        if #result ~= 0 then

            MySQL.Async.fetchAll('SELECT * FROM department_members WHERE departmentID = @deptId AND userID = @userID', {['@deptId'] = deptId, ['@userID'] = result[1].id}, function(result2)

                if #result2[1] ~= 0 then

                    cb(true)

                else

                    cb(false)

                end

            end)

        end

    end)

end)

Framework.RegisterServerCallback('Framework:FivePD:GetDepartmentMember', function(source, cb, deptId)

    local identifier = Framework.GetIdentifier(source)

    MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @license', {['@license'] = identifier}, function(result)

        local FivePDUser = result[1]
        local FivePDUserId = FivePDUser.id

        MySQL.Async.fetchAll('SELECT * FROM department_members WHERE departmentID = @deptId AND userID = @userID', {['@deptId'] = deptId, ['@userID'] = FivePDUserId}, function(result2)

            if #result2 ~= 0 then

                cb(result2[1])

            else

                cb(false)

            end

        end)

    end)

end)