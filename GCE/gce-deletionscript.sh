echo "Warning: You have executed deletion script to delete gce instance"
echo "Please enter name of gce instance: "
read gce
echo "Please Enter name of the project: "
read proj
echo "Please type to delete to destroy instance: ", $gce, "in project", $proj

read confirm

if [ $confirm = delete ]
then
echo "executing deletion script"

gcloud compute instances delete $gce --project="$proj"

else
echo "User not confirmed on deletion of gce"
fi