json.error "something wen't wrong"

if @user.present?
  json.error "#{pluralize(@user.errors.count, "error")} found"
  json.errors @user.errors.map { |e| e.full_message }
end
